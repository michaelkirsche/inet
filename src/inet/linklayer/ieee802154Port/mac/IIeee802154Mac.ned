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

package inet.linklayer.ieee802154Port.mac;

import inet.linklayer.contract.IMACProtocol;

//
// Module interface for IEEE 802.15.4 MAC modules
//
moduleinterface IIeee802154Mac extends IMACProtocol
{
    parameters:
        string uliModule;   // name of the 802.15.4 Upper Layer Interface (ULI) module
        string phyModule;   // name of the 802.15.4 Physical Layer (PHY) module
        @display("i=block/rxtx");
}