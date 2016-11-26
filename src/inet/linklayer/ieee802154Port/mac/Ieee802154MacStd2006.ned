//
// Copyright (C) 2016 Michael Kirsche   (redesigned for INET 3.x)
// Copyright (C) 2015 Michael Kirsche   (ported for INET 2.x)
// Copyright (C) 2013 Matti Schnurbusch (original version)
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

package inet.linklayer.ieee802154Port.mac;

// interface class of all IEEE 802.15.4 MAC modules
import inet.linklayer.ieee802154Port.mac.IIeee802154Mac;

import inet.linklayer.base.MACProtocolBase;
// in case of errors in OMNeT 4.x, uncomment the following parts instead of the previous import
// near copy-paste of inet.linklayer.base.MACProtocolBase to work around "compound-module cannot extend a simple-module" error in OMNeT++ 4.x
//module LayeredProtocolBase
//{
//    parameters:
//        @signal[packetSentToUpper](type=cPacket);
//        @signal[packetReceivedFromUpper](type=cPacket);
//        @signal[packetFromUpperDropped](type=cPacket);
//        @signal[packetSentToLower](type=cPacket);
//        @signal[packetReceivedFromLower](type=cPacket);
//        @signal[packetFromLowerDropped](type=cPacket);
//}
//
//// near copy-paste of inet.linklayer.base.MACProtocolBase to work around "compound-module cannot extend a simple-module" error in OMNeT++ 4.x
//module MACProtocolBase extends LayeredProtocolBase
//{
//    parameters:
//        string interfaceTableModule;
//        int mtu @unit("B") = default(2304B);
//        @display("i=block/rxtx");
//    gates:
//        input upperLayerIn @labels(INetworkDatagram/down);
//        output upperLayerOut @labels(INetworkDatagram/up);
//        input lowerLayerIn @labels(ILinkLayerFrame/up);
//        output lowerLayerOut @labels(ILinkLayerFrame/down);
//}

// Std. IEEE 802.15.4-2006 Medium Access Control (MAC) Layer 

module Ieee802154MacStd2006 extends MACProtocolBase like IIeee802154Mac
{
	parameters:
	    @class(Ieee802154MacStd2006);
        string uliModule;   // name of the 802.15.4 Upper Layer Interface (ULI) module
        string phyModule;   // name of the 802.15.4 Physical Layer (PHY) module
        
        bool macDebug = default(false);         	// debug output switch for the IEEE 802.15.4 MAC module
        
        string macAddr = default("auto"); 	    	// MAC address as hex string (16 hex digits), or "auto" 
        
        int BeaconOrder = default (15);         	// value (0..15), default 15 = beacon disabled 
        int SuperframeOrder = default (15);     	// value (0..15), default 15 = superframe/beacons disabled

}
