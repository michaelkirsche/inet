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

import inet.linklayer.contract.IMACProtocol;

//
// Module interface for all IEEE 802.15.4 MAC modules
//
moduleinterface IIeee802154Mac extends IMACProtocol
{
    parameters:
        @display("i=block/rxtx");
    gates:
        input inMLME_SAP @labels(INetworkDatagram/down);
        input inMCPS_SAP @labels(INetworkDatagram/down);
        
        output outMLME_SAP @labels(INetworkDatagram/up);
        output outMCPS_SAP @labels(INetworkDatagram/up);
        
        input inPD_SAP @labels(ILinkLayerFrame/up);
        input inPLME_SAP @labels(ILinkLayerFrame/up);
        
        output outPD_SAP @labels(ILinkLayerFrame/down);
        output outPLME_SAP @labels(ILinkLayerFrame/down);
}