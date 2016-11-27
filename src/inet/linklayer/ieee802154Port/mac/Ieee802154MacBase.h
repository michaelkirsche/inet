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

#ifndef INET_LINKLAYER_IEEE802154PORT_MAC_IEEE802154MACBASE_H_
#define INET_LINKLAYER_IEEE802154PORT_MAC_IEEE802154MACBASE_H_

#include "inet/common/INETDefs.h"
#include "inet/physicallayer/contract/packetlevel/IRadio.h"
#include "inet/linklayer/base/MACProtocolBase.h"

namespace inet {
namespace ieee802154Port {

using namespace physicallayer;

//class Ieee802154MacFrame;    TODO: introduce a class for IEEE 802.15.4 MAC Frames

/**
 *  This is the Base Class for IEEE 802.15.4 MAC implementations
 */
class INET_API Ieee802154MacBase : public MACProtocolBase
{
    protected:
        MACAddress address; // only because createInterfaceEntry() needs it
                            // FIXME switch to 64-Bit extended MACaddress once it is available

        IRadio *radio = nullptr;

        IRadio::TransmissionState transmissionState = IRadio::TransmissionState::TRANSMISSION_STATE_UNDEFINED;

        static simsignal_t stateSignal;
        static simsignal_t radioStateSignal;

    protected:
        // initialization
        virtual int numInitStages() const override
        {
            return NUM_INIT_STAGES;
        }
        virtual void initialize(int) override;

        // finish
        virtual void finish() override;

        virtual InterfaceEntry *createInterfaceEntry() override;

        /** @brief Handle commands (msg kind+control info) coming from upper layers */
        virtual void handleUpperCommand(cMessage *msg) override;

        /** @brief Handle timer self messages */
        virtual void handleSelfMessage(cMessage *msg) override;

        /** @brief Handle messages from upper layer */
        virtual void handleUpperPacket(cPacket *msg) override;

        /** @brief Handle messages from lower (physical) layer */
        virtual void handleLowerPacket(cPacket *msg) override;

        virtual bool handleNodeStart(IDoneCallback *doneCallback) override;
        virtual bool handleNodeShutdown(IDoneCallback *doneCallback) override;
        virtual void handleNodeCrash() override;

        void receiveSignal(cComponent *source, simsignal_t signalID, long value, cObject *details) override;
        void configureRadioMode(IRadio::RadioMode radioMode);

//        virtual InterfaceEntry *createInterfaceEntry() override;
//        virtual const MACAddress& isInterfaceRegistered();
//        void transmissionStateChanged(IRadio::TransmissionState transmissionState);

    public:
        Ieee802154MacBase();
        virtual ~Ieee802154MacBase();
};

}
/* namespace ieee802154Port */
} /* namespace inet */

#endif /* INET_LINKLAYER_IEEE802154PORT_MAC_IEEE802154MACBASE_H_ */
