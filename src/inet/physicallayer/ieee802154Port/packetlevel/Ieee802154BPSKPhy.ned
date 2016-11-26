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

package inet.physicallayer.ieee802154Port.packetlevel;

import inet.physicallayer.ieee802154Port.IIeee802154Phy;

import inet.physicallayer.idealradio.IdealRadio;

//
// The future implementation of the 802.15.4 radio
// Used in combination with appropriate Radio Medium, Transmitter 
// and Receiver classes / NED-files
//
module Ieee802154BPSKPhy extends IdealRadio like IIeee802154Phy
{
    // nothing here yet, we use IdealRadio until PHY/Radio porting has started
    parameters:
        string macModule;
}
