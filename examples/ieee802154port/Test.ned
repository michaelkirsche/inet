//
// Copyright (C) 2016   Michael Kirsche
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
//

package inet.examples.ieee802154port;

import inet.applications.ethernet.EtherAppCli;  // TODO choose different traffic generator
import inet.common.queue.Sink;                  // receiver application, a simple packet-discarding sink
import inet.mobility.single.CircleMobility;
import inet.mobility.static.StationaryMobility;
import inet.physicallayer.contract.packetlevel.IRadioMedium;
import inet.visualizer.integrated.IntegratedCanvasVisualizer;
import inet.linklayer.ieee802154Port.Ieee802154PortNic;

module SenderNode
{
    parameters:
        @display("i=device/wifilaptop");
        @networkNode();
        *.interfaceTableModule = "";
    gates:
        input radioIn @directIn;

    submodules:
        trafficGenerator: EtherAppCli {
            parameters:
                registerSAP = false;
                @display("b=40,24;p=210,70,col");
        }
        nic: Ieee802154PortNic {
            parameters:
                @display("p=112,134;q=queue");
        }
        mobility: CircleMobility {
            parameters:
                @display("p=45,60");
        }
    connections allowunconnected:
        nic.radioIn <-- radioIn;
        trafficGenerator.out --> nic.upperLayerIn;
}

module ReceiverNode
{
    parameters:
        @display("i=device/antennatower");
        @networkNode();
        *.interfaceTableModule = "";
    gates:
        input radioIn @directIn;

    submodules:
        trafficSink: Sink {
            parameters:
                @display("p=210,70,col");
        }
        nic: Ieee802154PortNic {
            parameters:
                @display("p=112,134;q=queue");
        }
        mobility: StationaryMobility {
            parameters:
                @display("p=45,60");
        }
    connections allowunconnected:
        nic.radioIn <-- radioIn;
        trafficSink.in++ <-- nic.upperLayerOut;
}

network Test
{
    parameters:
        int numSender = default(1);
        string radioMediumType = default("IdealRadioMedium");
        @display("b=297,203");
    submodules:
        sender[numSender]: SenderNode {
            parameters:
                @display("r=,,#707070");
        }
        receiver: ReceiverNode {
            parameters:
                @display("p=350,350;r=,,#707070");
        }
        visualizer: IntegratedCanvasVisualizer {
            parameters:
                @display("p=62,122");
        }
        radioMedium: <radioMediumType> like IRadioMedium {
            parameters:
                @display("p=61,46");
        }
}

