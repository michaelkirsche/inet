//
// Copyright (C) 2016 Michael Kirsche
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

#include "Ieee802154MacBase.h"
#include "inet/networklayer/contract/IInterfaceTable.h"
#include "inet/common/INETUtils.h"
#include "inet/common/ModuleAccess.h"

namespace inet {
namespace ieee802154Port {

simsignal_t Ieee802154MacBase::stateSignal = SIMSIGNAL_NULL;
simsignal_t Ieee802154MacBase::radioStateSignal = SIMSIGNAL_NULL;

Ieee802154MacBase::Ieee802154MacBase()
{
    // Auto-generated constructor stub
    // TODO any initializations that need to be done here instead of Ieee802154MacBase::initialize ?

}

Ieee802154MacBase::~Ieee802154MacBase()
{
    // Auto-generated destructor stub
    // TODO cancel timers. record statistics in Ieee802154MacBase::finish
}

void Ieee802154MacBase::initialize(int stage)
{
    MACProtocolBase::initialize(stage);

    if (stage == INITSTAGE_LOCAL) {
        EV_INFO_C("mac") << "Initializing stage 0\n";

        // initialize radio module
        cModule *radioModule = gate("lowerLayerOut")->getNextGate()->getOwnerModule();
        radioModule->subscribe(IRadio::radioModeChangedSignal, this);
        radioModule->subscribe(IRadio::receptionStateChangedSignal, this);
        radioModule->subscribe(IRadio::transmissionStateChangedSignal, this);
        radioModule->subscribe(IRadio::receivedSignalPartChangedSignal, this);
        radio = check_and_cast<IRadio *>(radioModule);

        // initialize MAC address
        const char *addressString = par("macAddr");
        if (!strcmp(addressString, "auto")) {
            // change module parameter from "auto" to concrete address
            par("macAddr").setStringValue(MACAddress::generateAutoAddress().str().c_str());
            addressString = par("macAddr");
        }
        address.setAddress(addressString);

    }
    else if (stage == INITSTAGE_LINK_LAYER) {
        EV_INFO_C("mac") << "Initializing stage 4\n";

        // TODO register interfaces
//        registerInterface();

        if (isOperational)
            radio->setRadioMode(IRadio::RADIO_MODE_RECEIVER);
//        if (isInterfaceRegistered().isUnspecified()) //TODO do we need multi-MAC feature? if so, should they share interfaceEntry??  --Andras
//            registerInterface();
    }
}

void Ieee802154MacBase::finish()
{
    // TODO add statistic collection if needed
    return;
}

InterfaceEntry *Ieee802154MacBase::createInterfaceEntry()
{
    // TODO create the necessary interface entry

    InterfaceEntry *e = new InterfaceEntry(this);

    // address
    e->setMACAddress(address);
//    e->setInterfaceToken(address.formInterfaceIdentifier());
//
//    e->setMtu(par("mtu").longValue());
//
//    // capabilities
//    e->setBroadcast(true);
//    e->setMulticast(true);
//    e->setPointToPoint(false);

    return e;
}

void Ieee802154MacBase::handleSelfMessage(cMessage *msg)
{
    EV_DEBUG_C("mac") << "nothing done here in handleSelfMessage yet \n";
    ASSERT(false);
}

void Ieee802154MacBase::handleUpperPacket(cPacket *msg)
{
    EV_DEBUG_C("mac") << "nothing done here in handleUpperPacket yet \n";
}

void Ieee802154MacBase::handleLowerPacket(cPacket *msg)
{
    EV_DEBUG_C("mac") << "nothing done here in handleLowerPacket yet \n";
}

void Ieee802154MacBase::handleUpperCommand(cMessage *msg)
{
    EV_DEBUG_C("mac") << "nothing done here in handleUpperCommand yet \n";
}

bool Ieee802154MacBase::handleNodeStart(IDoneCallback *doneCallback)
{
    // FIXME taken from 802.11 without adjustments
    if (!doneCallback)
        return true;    // do nothing when called from initialize()

    bool ret = MACProtocolBase::handleNodeStart(doneCallback);
    radio->setRadioMode(IRadio::RADIO_MODE_RECEIVER);
    return ret;
}

bool Ieee802154MacBase::handleNodeShutdown(IDoneCallback *doneCallback)
{
    // FIXME taken from 802.11 without adjustments
    bool ret = MACProtocolBase::handleNodeStart(doneCallback);
    handleNodeCrash();
    return ret;
}

void Ieee802154MacBase::handleNodeCrash()
{
    // FIXME taken from 802.11 without adjustments
}

void Ieee802154MacBase::receiveSignal(cComponent *source, simsignal_t signalID, long value, cObject *details)
{
    // FIXME taken from 802.11 without adjustments
    Enter_Method_Silent("receiveSignal()");
//    if (signalID == IRadio::receptionStateChangedSignal) {
//        //rx->receptionStateChanged((IRadio::ReceptionState)value);
//    }
//    else if (signalID == IRadio::transmissionStateChangedSignal) {
//        auto oldTransmissionState = transmissionState;
//        transmissionState = (IRadio::TransmissionState)value;
//
//        bool transmissionFinished = (oldTransmissionState == IRadio::TRANSMISSION_STATE_TRANSMITTING && transmissionState == IRadio::TRANSMISSION_STATE_IDLE);
//
//        if (transmissionFinished) {
//            tx->radioTransmissionFinished();
//            EV_DEBUG << "changing radio to receiver mode\n";
//            configureRadioMode(IRadio::RADIO_MODE_RECEIVER);    //FIXME this is in a very wrong place!!! should be done explicitly from UpperMac!
//        }
//        rx->transmissionStateChanged(transmissionState);
//    }
//    else if (signalID == IRadio::receivedSignalPartChangedSignal) {
//        rx->receivedSignalPartChanged((IRadioSignal::SignalPart)value);
//    }
}

void Ieee802154MacBase::configureRadioMode(IRadio::RadioMode radioMode)
{
    // FIXME taken from 802.11 without adjustments
    if (radio->getRadioMode() != radioMode) {
        ConfigureRadioCommand *configureCommand = new ConfigureRadioCommand();
        configureCommand->setRadioMode(radioMode);
        cMessage *message = new cMessage("configureRadioMode", RADIO_C_CONFIGURE);
        message->setControlInfo(configureCommand);
        sendDown(message);
    }
}

} /* namespace ieee802154Port */
} /* namespace inet */
