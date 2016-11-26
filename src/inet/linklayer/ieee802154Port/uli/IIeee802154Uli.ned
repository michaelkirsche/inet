//
// Copyright (C) 2016 Michael Kirsche
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program; if not, see <http://www.gnu.org/licenses/>.
//


package inet.linklayer.ieee802154Port.uli;

//
// This is not a concrete module type, but a prototype for all types of 
// IEEE 802.15.4 Upper Layer Interface (ULI) module types. 
// It exists to specify what gates a ULI module should have in order  
// to be usable within ~Ieee802154Nic.
//
moduleinterface IIeee802154Uli
{
    parameters:
        @display("i=block/cogwheel");
        string macModule;               // Name of the 802.15.4 MAC module
    gates:
        // in-/output gates to/from the upper layer
        input upperLayerIn;
        output upperLayerOut;
        
        // in-/output gates to/from the 802.15.4 MAC layer
        input macIn @labels(Ieee802154Frame);
        output macOut @labels(Ieee802154Frame);
}
