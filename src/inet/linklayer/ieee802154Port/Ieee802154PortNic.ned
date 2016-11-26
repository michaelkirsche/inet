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

// Interface classes for wireless NIC and Radio
import inet.linklayer.contract.IWirelessNic;
import inet.physicallayer.contract.packetlevel.IRadio;

// Interface class for IEEE 802.15.4 Upper Layer Interface Modules 
// (e.g., LLC, SSCS, queue or other upper layer interfaces / converters)
import inet.linklayer.ieee802154Port.uli.IIeee802154Uli;

// Interface class for IEEE 802.15.4 MAC modules 
// (e.g., 2006 revision, 2009, 2015, etc.)
import inet.linklayer.ieee802154Port.mac.IIeee802154Mac;

// Interface class for IEEE 802.15.4 PHY/Radio modules 
// (e.g., 802.15.4 PHY 2006 revision, IdealRadio, etc.)
import inet.physicallayer.ieee802154Port.IIeee802154Phy;

// 
// This Network Interface Card (NIC) implements an IEEE 802.15.4 NIC.
// It represents the PHY and MAC layer inside a compound module.
// You can choose different MAC and PHY types. 
// Check the according NED files for additional information.
//
module Ieee802154PortNic like IWirelessNic
{
    parameters:
        string interfaceTableModule;
        string energySourceModule = default("");
        //*.interfaceTableModule = default(absPath(interfaceTableModule));
        //*.energySourceModule = default(absPath(energySourceModule));

        string uliType = default(""); 	// choose an Upper Layer Interface (ULI) module (e.g., SSCS, LLC, 802.15.12 ULI)
        string macType = default("Ieee802154MacStd2006"); // choose from various 802.15.4 MAC types (e.g., Std2006, Std2009, Std2015)
        string phyType = default("Ieee802154BPSKPhy"); // choose a compatible radio (e.g., Ieee802154BPSKPhy, Ieee802154QPSKPhy)

        @display("i=block/ifcard;bgb=154,249");

    gates:
        input upperLayerIn; // to upper layers
        output upperLayerOut; // from upper layers
        input radioIn @labels(IRadioFrame); // to receive radio frames

    submodules:
        uli: <uliType> like IIeee802154Uli if uliType != "" {
            parameters:
                macModule = "^.mac";
                @display("p=80,50;i=block/fork");
        }

        mac: <macType> like IIeee802154Mac {
            parameters:
//                uliModule = (uliType == "" ? "" : "^.uli");   // FIXME problem of "no parameter uliModule" if no uliType was selected
//                phyModule = "^.phy";
                @display("p=80,125;i=block/mac");
        }

        phy: <phyType> like IIeee802154Phy {
            parameters:
                macModule = "^.mac";
                @display("p=80,200;i=block/wrxtx");
        }

    connections:

        // connections between upper layer and ULI / MAC modules
        if uliType != "" {
            upperLayerIn --> { @display("m=a"); } --> uli.upperLayerIn;
            uli.upperLayerOut --> { @display("m=a"); } --> upperLayerOut;

            uli.macOut --> mac.upperLayerIn;
            mac.upperLayerOut --> uli.macIn;
        }

        // if no Upper Layer Interface (ULI) module is used, packets are 
        // directly sent to the MAC data service access point (MCPS-SAP)
        // WARNING: packets need to be IEEE 802.15.4 MAC-compatible, 
        // if they are not, the simulation will crash !!!
        // Use an "upper layer interface" module (like SSCS) to convert 
        // non-compatible frames into 802.15.4-compatible frames 
        if uliType == "" {
            upperLayerIn --> { @display("m=a"); } --> mac.upperLayerIn;
            mac.upperLayerOut --> { @display("m=a"); } --> upperLayerOut;
        }
                
        // connections between MAC and PHY / Radio modules
        mac.lowerLayerOut --> phy.upperLayerIn;
        phy.upperLayerOut --> mac.lowerLayerIn;

        // connection for reception  of radio air frames
        radioIn --> { @display("m=a"); } --> phy.radioIn;
}
