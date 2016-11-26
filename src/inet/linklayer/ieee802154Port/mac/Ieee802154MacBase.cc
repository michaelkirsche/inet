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

Ieee802154MacBase::Ieee802154MacBase()
{
    // TODO Auto-generated constructor stub

}

Ieee802154MacBase::~Ieee802154MacBase()
{
    // TODO Auto-generated destructor stub
}

void Ieee802154MacBase::initialize(int stage)
{
    MACProtocolBase::initialize(stage);

    if (stage == INITSTAGE_LOCAL) {
        EV << "Initializing stage 0\n";

        // TODO initialize radio

        // TODO initialize MAC address

    }
    else if (stage == INITSTAGE_LINK_LAYER) {
        EV << "Initializing stage 4\n";

        // TODO register interfaces
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

//    // address
//    e->setMACAddress(address);
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
    EV_DEBUG << "nothing done here in handleSelfMessage yet \n";
    ASSERT(false);
}

void Ieee802154MacBase::handleUpperPacket(cPacket *msg)
{
    EV_DEBUG << "nothing done here in handleUpperPacket yet \n";
}

void Ieee802154MacBase::handleLowerPacket(cPacket *msg)
{
    EV_DEBUG << "nothing done here in handleLowerPacket yet \n";
}

void Ieee802154MacBase::handleUpperCommand(cMessage *msg)
{
    EV_DEBUG << "nothing done here in handleUpperCommand yet \n";
}

// FIXME
bool Ieee802154MacBase::handleNodeStart(IDoneCallback *doneCallback)
{
    if (!doneCallback)
        return true;    // do nothing when called from initialize()

    bool ret = MACProtocolBase::handleNodeStart(doneCallback);
    radio->setRadioMode(IRadio::RADIO_MODE_RECEIVER);
    return ret;
}

// FIXME
bool Ieee802154MacBase::handleNodeShutdown(IDoneCallback *doneCallback)
{
    bool ret = MACProtocolBase::handleNodeStart(doneCallback);
    handleNodeCrash();
    return ret;
}

// FIXME
void Ieee802154MacBase::handleNodeCrash()
{
}

} /* namespace ieee802154Port */
} /* namespace inet */
