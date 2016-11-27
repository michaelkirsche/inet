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

import inet.linklayer.base.MACProtocolBase;
// interface class of all IEEE 802.15.4 MAC modules
import inet.linklayer.ieee802154Port.mac.IIeee802154Mac;

// Std. IEEE 802.15.4-2006 Medium Access Control (MAC) Layer 

module Ieee802154MacStd2006 extends MACProtocolBase like IIeee802154Mac
{
	parameters:
	    @class(Ieee802154MacStd2006);
        string uliModule;   // name of the 802.15.4 Upper Layer Interface (ULI) module
        string phyModule;   // name of the 802.15.4 Physical Layer (PHY) module
        
        string macAddr = default("auto"); 	// MAC address as hex string (16 hex digits), or "auto" 
                                            // "auto" values are replaced by a generated MAC address in init stage 0  
        
        int BeaconOrder = default (15);     // value (0..15), default 15 = beacon disabled 
        int SuperframeOrder = default (15); // value (0..15), default 15 = superframe/beacons disabled

}
