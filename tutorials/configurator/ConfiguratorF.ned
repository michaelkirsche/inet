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

package inet.tutorials.configurator;

import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.node.ethernet.Eth100M;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import inet.node.inet.WirelessHost;
import inet.node.wireless.AccessPoint;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import inet.visualizer.integrated.IntegratedCanvasVisualizer;


network ConfiguratorF
{
    @display("bgb=1609.9875,1034.55");
    submodules:
        area1router: Router {
            @display("p=519.75,535.8375");
        }
        area1wirelesshost1: WirelessHost {
            @display("p=246.26251,368.775");
        }
        area1wirelesshost3: WirelessHost {
            @display("p=404.6625,506.1375");
        }
        area1wirelesshost2: WirelessHost {
            @display("p=377.4375,409.61252");
        }
        area3host3: StandardHost {
            @display("p=905.85004,773.4375");
        }
        area3host2: StandardHost {
            @display("p=794.47504,773.4375");
        }
        area3host1: StandardHost {
            @display("p=678.15,773.4375");
        }
        area3router: Router {
            @display("p=780.8625,535.8375");
        }
        area3Switch: EtherSwitch {
            @display("p=805.6125,665.775");
        }
        configurator: IPv4NetworkConfigurator {
            @display("p=77,46");
        }
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=81,107");
        }
        visualizer: IntegratedCanvasVisualizer {
            @display("p=276,46");
        }
        area2router: Router {
            @display("p=657.1125,356.4");
        }
        area2AP: AccessPoint {
            @display("p=763.53754,280.9125");
        }
        area2wirelesshost1: WirelessHost {
            @display("p=876.15,173.25");
        }
        area2wirelesshost2: WirelessHost {
            @display("p=936.78754,279.67502");
        }
        area2wirelesshost3: WirelessHost {
            @display("p=876.15,382.3875");
        }
    connections:
        area3host1.ethg++ <--> Eth100M <--> area3Switch.ethg++;
        area3host2.ethg++ <--> Eth100M <--> area3Switch.ethg++;
        area3Switch.ethg++ <--> Eth100M <--> area3host3.ethg++;
        area3Switch.ethg++ <--> Eth100M <--> area3router.ethg++;
        area3router.ethg++ <--> Eth100M <--> area1router.ethg++;
        area1router.ethg++ <--> Eth100M <--> area1wirelesshost3.ethg++;
        area1router.ethg++ <--> Eth100M <--> area2router.ethg++;
        area2router.ethg++ <--> Eth100M <--> area3router.ethg++;
        area2router.ethg++ <--> Eth100M <--> area2AP.ethg++;
}
