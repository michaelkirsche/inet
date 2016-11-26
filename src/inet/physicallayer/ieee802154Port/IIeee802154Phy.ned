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

package inet.physicallayer.ieee802154Port;

import inet.physicallayer.contract.packetlevel.IRadio;

//
// Module interface for IEEE 802.15.4 PHY / Radio modules
// This is not a concrete module type, but a prototype for all types of 
// IEEE 802.15.4 Physical Layer (PHY) module types.
// It exists to specify what gates a PHY module should have in order  
// to be usable within ~Ieee802154Nic.
//
moduleinterface IIeee802154Phy extends IRadio
{
    parameters:
        @display("i=block/rxtx");
        string macModule;   // Name of the 802.15.4 MAC module
}