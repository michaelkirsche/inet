/*
 * Copyright (C) 2003 Andras Varga; CTIE, Monash University, Australia
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

#include <stdio.h>
#include <string.h>
#include <math.h>

#include "inet/applications/ethernet/EtherAppClient.h"

#include "inet/applications/ethernet/EtherApp_m.h"
#include "inet/linklayer/common/Ieee802Ctrl.h"
#include "inet/linklayer/common/Ieee802SapTag_m.h"
#include "inet/linklayer/common/MacAddressTag_m.h"
#include "inet/common/lifecycle/NodeOperations.h"
#include "inet/common/ModuleAccess.h"
#include "inet/common/packet/Packet.h"

namespace inet {

Define_Module(EtherAppClient);

EtherAppClient::~EtherAppClient()
{
    cancelAndDelete(timerMsg);
}

void EtherAppClient::initialize(int stage)
{
    cSimpleModule::initialize(stage);

    if (stage == INITSTAGE_LOCAL) {
        reqLength = &par("reqLength");
        respLength = &par("respLength");
        sendInterval = &par("sendInterval");

        localSAP = par("localSAP");
        remoteSAP = par("remoteSAP");

        seqNum = 0;
        WATCH(seqNum);

        // statistics
        packetsSent = packetsReceived = 0;
        WATCH(packetsSent);
        WATCH(packetsReceived);

        startTime = par("startTime");
        stopTime = par("stopTime");
        if (stopTime >= SIMTIME_ZERO && stopTime < startTime)
            throw cRuntimeError("Invalid startTime/stopTime parameters");
    }
    else if (stage == INITSTAGE_APPLICATION_LAYER) {
        if (isGenerator())
            timerMsg = new cMessage("generateNextPacket");

        nodeStatus = dynamic_cast<NodeStatus *>(findContainingNode(this)->getSubmodule("status"));

        if (isNodeUp() && isGenerator())
            scheduleNextPacket(true);
    }
}

void EtherAppClient::handleMessage(cMessage *msg)
{
    if (!isNodeUp())
        throw cRuntimeError("Application is not running");
    if (msg->isSelfMessage()) {
        if (msg->getKind() == START) {
            bool registerSAP = par("registerSAP");
            if (registerSAP)
                registerDSAP(localSAP);

            destMACAddress = resolveDestMACAddress();
            // if no dest address given, nothing to do
            if (destMACAddress.isUnspecified())
                return;
        }
        sendPacket();
        scheduleNextPacket(false);
    }
    else
        receivePacket(check_and_cast<Packet *>(msg));
}

bool EtherAppClient::handleOperationStage(LifecycleOperation *operation, int stage, IDoneCallback *doneCallback)
{
    Enter_Method_Silent();
    if (dynamic_cast<NodeStartOperation *>(operation)) {
        if (static_cast<NodeStartOperation::Stage>(stage) == NodeStartOperation::STAGE_APPLICATION_LAYER && isGenerator())
            scheduleNextPacket(true);
    }
    else if (dynamic_cast<NodeShutdownOperation *>(operation)) {
        if (static_cast<NodeShutdownOperation::Stage>(stage) == NodeShutdownOperation::STAGE_APPLICATION_LAYER)
            cancelNextPacket();
    }
    else if (dynamic_cast<NodeCrashOperation *>(operation)) {
        if (static_cast<NodeCrashOperation::Stage>(stage) == NodeCrashOperation::STAGE_CRASH)
            cancelNextPacket();
    }
    else
        throw cRuntimeError("Unsupported lifecycle operation '%s'", operation->getClassName());
    return true;
}

bool EtherAppClient::isNodeUp()
{
    return !nodeStatus || nodeStatus->getState() == NodeStatus::UP;
}

bool EtherAppClient::isGenerator()
{
    return par("destAddress").stringValue()[0];
}

void EtherAppClient::scheduleNextPacket(bool start)
{
    simtime_t cur = simTime();
    simtime_t next;
    if (start) {
        next = cur <= startTime ? startTime : cur;
        timerMsg->setKind(START);
    }
    else {
        next = cur + *sendInterval;
        timerMsg->setKind(NEXT);
    }
    if (stopTime < SIMTIME_ZERO || next < stopTime)
        scheduleAt(next, timerMsg);
}

void EtherAppClient::cancelNextPacket()
{
    if (timerMsg)
        cancelEvent(timerMsg);
}

MacAddress EtherAppClient::resolveDestMACAddress()
{
    MacAddress destMACAddress;
    const char *destAddress = par("destAddress");
    if (destAddress[0]) {
        // try as mac address first, then as a module
        if (!destMACAddress.tryParse(destAddress)) {
            cModule *destStation = getModuleByPath(destAddress);
            if (!destStation)
                throw cRuntimeError("cannot resolve MAC address '%s': not a 12-hex-digit MAC address or a valid module path name", destAddress);

            cModule *destMAC = destStation->getSubmodule("eth");
            if (!destMAC)
                throw cRuntimeError("module '%s' has no 'eth' submodule", destAddress);

            destMACAddress = check_and_cast<InterfaceEntry *>(destMAC)->getMacAddress();
        }
    }
    return destMACAddress;
}

void EtherAppClient::registerDSAP(int dsap)
{
    EV_DEBUG << getFullPath() << " registering DSAP " << dsap << "\n";

    Ieee802RegisterDsapCommand *etherctrl = new Ieee802RegisterDsapCommand();
    etherctrl->setDsap(dsap);
    cMessage *msg = new cMessage("register_DSAP", IEEE802CTRL_REGISTER_DSAP);
    msg->setControlInfo(etherctrl);

    send(msg, "out");
}

void EtherAppClient::sendPacket()
{
    seqNum++;

    char msgname[30];
    sprintf(msgname, "req-%d-%ld", getId(), seqNum);
    EV_INFO << "Generating packet `" << msgname << "'\n";

    Packet *datapacket = new Packet(msgname, IEEE802CTRL_DATA);
    const auto& data = makeShared<EtherAppReq>();

    data->setRequestId(seqNum);

    long len = *reqLength;
    data->setChunkLength(B(len));

    long respLen = *respLength;
    data->setResponseBytes(respLen);
    datapacket->insertAtBack(data);

    datapacket->addTagIfAbsent<MacAddressReq>()->setDestAddress(destMACAddress);
    auto ieee802SapReq = datapacket->addTagIfAbsent<Ieee802SapReq>();
    ieee802SapReq->setSsap(localSAP);
    ieee802SapReq->setDsap(remoteSAP);

    emit(packetSentSignal, datapacket);
    send(datapacket, "out");
    packetsSent++;
}

void EtherAppClient::receivePacket(Packet *msg)
{
    EV_INFO << "Received packet `" << msg->getName() << "'\n";

    packetsReceived++;
    emit(packetReceivedSignal, msg);
    delete msg;
}

void EtherAppClient::finish()
{
    cancelAndDelete(timerMsg);
    timerMsg = nullptr;
}

} // namespace inet

