//
// Copyright (C) 2016 Michael Kirsche   (redesigned for INET 3.x)
// Copyright (C) 2015 Michael Kirsche   (ported for INET 2.x)
// Copyright (C) 2013 Matti Schnurbusch (original code)
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

package inet.linklayer.ieee802154Port;

import inet.linklayer.contract.IWirelessNic;
import inet.physicallayer.contract.packetlevel.IRadio;

// essentially a ring buffer to queue frames before they reach the MAC
import inet.linklayer.ieee802154Port.MsgBuffer;

// 
// This Network Interface Card (NIC) implements an IEEE 802.15.4 NIC.
// It represents the PHY and MAC layer inside a compound module.
//
// A (replaceable) buffer is placed above the MAC layer
// TODO: the buffer might be removed or shifted to the INET common components later on
//
module Ieee802154PortNic like IWirelessNic
{
    parameters:
        string interfaceTableModule;
        string energySourceModule = default("");
        string radioType = default("IdealRadio");	// TODO: change to 802.15.4 radio when starting to port PHY
        string macType = default("Ieee802154Mac");   // TODO: add different 802.15.4 MAC types (maybe 2006-rev, 2009-rev, UWB, ...)
        //*.interfaceTableModule = default(absPath(interfaceTableModule));
        //*.energySourceModule = default(absPath(energySourceModule));
        @display("i=block/ifcard;bgb=154,249");

    gates:
        input upperLayerIn; // to upper layers
        output upperLayerOut; // from upper layers
        input radioIn @labels(IRadioFrame); // to receive radio frames

        // original model used separate gates/connections for Data and Management frames
        //input inData;
        //input inMngt;
        //output outData;
        //output outMngt;

    submodules:
        buffer: MsgBuffer {
            parameters:
                @display("p=80,50;i=block/buffer");
        }

        mac: <macType> like IIeee802154Mac {
            parameters:
                @display("p=80,125;i=block/mac");
        }

        radio: <radioType> like IRadio {	
            parameters:
                @display("p=80,200;i=block/wrxtx");
        }

    connections:
        upperLayerIn --> buffer.upperLayerIn;
        upperLayerOut <-- buffer.upperLayerOut;

        buffer.outMCPS --> { @display("m=n"); } --> mac.inMCPS_SAP;
        buffer.inMCPS <-- mac.outMCPS_SAP;
        
        buffer.outMLME --> { @display("m=n"); } --> mac.inMLME_SAP; 
        buffer.inMLME <-- mac.outMLME_SAP;

        mac.lowerLayerOut --> radio.upperLayerIn;
        mac.upperLayerOut --> { @display("m=n"); } --> upperLayerOut;

        radioIn --> { @display("m=s"); } --> radio.radioIn;
        // currently for use with IRadio, 802.15.4 Radio has different interfaces (PD-SAP and PLME-SAP)
        mac.outPD_SAP --> radio.upperLayerIn;
        mac.outPLME_SAP --> radio.upperLayerIn;
                
        radio.upperLayerOut --> mac.inPD_SAP;
        radio.upperLayerOut --> mac.inPLME_SAP;
}
