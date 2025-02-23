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

#include "inet/applications/ethernet/EtherTrafGen.h"

#include "inet/common/ModuleAccess.h"
#include "inet/common/ProtocolTag_m.h"
#include "inet/common/lifecycle/NodeOperations.h"
#include "inet/common/packet/chunk/ByteCountChunk.h"
#include "inet/common/packet/Packet.h"
#include "inet/linklayer/common/Ieee802Ctrl.h"
#include "inet/linklayer/common/Ieee802SapTag_m.h"
#include "inet/linklayer/common/MacAddressTag_m.h"

namespace inet {

Define_Module(EtherTrafGen);

EtherTrafGen::EtherTrafGen()
{
    sendInterval = nullptr;
    numPacketsPerBurst = nullptr;
    packetLength = nullptr;
    timerMsg = nullptr;
    nodeStatus = nullptr;
}

EtherTrafGen::~EtherTrafGen()
{
    cancelAndDelete(timerMsg);
}

void EtherTrafGen::initialize(int stage)
{
    cSimpleModule::initialize(stage);

    if (stage == INITSTAGE_LOCAL) {
        sendInterval = &par("sendInterval");
        numPacketsPerBurst = &par("numPacketsPerBurst");
        packetLength = &par("packetLength");
        ssap = par("ssap");
        dsap = par("dsap");

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
            scheduleNextPacket(-1);
    }
}

void EtherTrafGen::handleMessage(cMessage *msg)
{
    if (!isNodeUp())
        throw cRuntimeError("Application is not running");
    if (msg->isSelfMessage()) {
        if (msg->getKind() == START) {
            destMACAddress = resolveDestMACAddress();
            // if no dest address given, nothing to do
            if (destMACAddress.isUnspecified())
                return;
        }
        sendBurstPackets();
        scheduleNextPacket(simTime());
    }
    else
        receivePacket(check_and_cast<Packet *>(msg));
}

bool EtherTrafGen::handleOperationStage(LifecycleOperation *operation, int stage, IDoneCallback *doneCallback)
{
    Enter_Method_Silent();
    if (dynamic_cast<NodeStartOperation *>(operation)) {
        if (static_cast<NodeStartOperation::Stage>(stage) == NodeStartOperation::STAGE_APPLICATION_LAYER && isGenerator())
            scheduleNextPacket(-1);
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

bool EtherTrafGen::isNodeUp()
{
    return !nodeStatus || nodeStatus->getState() == NodeStatus::UP;
}

bool EtherTrafGen::isGenerator()
{
    return par("destAddress").stringValue()[0];
}

void EtherTrafGen::scheduleNextPacket(simtime_t previous)
{
    simtime_t next;
    if (previous == -1) {
        next = simTime() <= startTime ? startTime : simTime();
        timerMsg->setKind(START);
    }
    else {
        next = previous + *sendInterval;
        timerMsg->setKind(NEXT);
    }
    if (stopTime < SIMTIME_ZERO || next < stopTime)
        scheduleAt(next, timerMsg);
}

void EtherTrafGen::cancelNextPacket()
{
    cancelEvent(timerMsg);
}

MacAddress EtherTrafGen::resolveDestMACAddress()
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

void EtherTrafGen::sendBurstPackets()
{
    int n = *numPacketsPerBurst;
    for (int i = 0; i < n; i++) {
        seqNum++;

        char msgname[40];
        sprintf(msgname, "pk-%d-%ld", getId(), seqNum);

        Packet *datapacket = new Packet(msgname, IEEE802CTRL_DATA);
        long len = *packetLength;
        const auto& payload = makeShared<ByteCountChunk>(B(len));
        datapacket->insertAtBack(payload);
        datapacket->removeTagIfPresent<PacketProtocolTag>();
//        datapacket->addTagIfAbsent<PacketProtocolTag>()->setProtocol(nullptr);
        datapacket->addTagIfAbsent<MacAddressReq>()->setDestAddress(destMACAddress);
        auto sapTag = datapacket->addTagIfAbsent<Ieee802SapReq>();
        sapTag->setSsap(ssap);
        sapTag->setDsap(dsap);

        EV_INFO << "Send packet `" << msgname << "' dest=" << destMACAddress << " length=" << len << "B ssap/dsap=" << ssap << "/" << dsap << "\n";
        emit(packetSentSignal, datapacket);
        send(datapacket, "out");
        packetsSent++;
    }
}

void EtherTrafGen::receivePacket(Packet *msg)
{
    EV_INFO << "Received packet `" << msg->getName() << "' length= " << msg->getByteLength() << "B\n";

    packetsReceived++;
    emit(packetReceivedSignal, msg);
    delete msg;
}

void EtherTrafGen::finish()
{
    cancelAndDelete(timerMsg);
    timerMsg = nullptr;
}

} // namespace inet

