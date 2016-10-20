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


network ConfiguratorD
{
    @display("bgb=2504.3225,1393.2375");
    submodules:
        area1subnet1host0: StandardHost {
            @display("p=380.2925,376.7875");
        }
        area1subnet1host1: StandardHost {
            @display("p=380.2925,227.82501");
        }
        area1subnet1host2: StandardHost {
            @display("p=380.2925,59.585003");
        }
        area1switch1: EtherSwitch {
            @display("p=683.43,300.96");
        }
        area2subnet1host1: StandardHost {
            @display("p=953.36005,1307.3651");
        }
        area2subnet1host2: StandardHost {
            @display("p=718.525,1307.3651");
        }
        area2subnet1host3: StandardHost {
            @display("p=476.68002,1307.3651");
        }
        area2switch1: EtherSwitch {
            @display("p=807.9025,1100.5701");
        }
        area3subnet1host1: StandardHost {
            @display("p=2216.9126,986.65753");
        }
        area3subnet1host2: StandardHost {
            @display("p=2244.9526,755.3275");
        }
        area3subnet1host3: StandardHost {
            @display("p=2265.9827,601.10754");
        }
        area3switch1: EtherSwitch {
            @display("p=1838.3726,623.89");
        }
        area1subnet2host1: WirelessHost {
            @display("p=368.02502,601.10754");
        }
        area1subnet2host2: WirelessHost {
            @display("p=368.02502,730.79254");
        }
        area1subnet2host3: WirelessHost {
            @display("p=332.975,914.80505");
        }
        area1AP: AccessPoint {
            @display("p=598.78503,683.43");
        }
        area2subnet2host1: StandardHost {
            @display("p=1961.0476,1281.0775");
        }
        area2subnet2host2: StandardHost {
            @display("p=1659.6176,1281.0775");
        }
        area2subnet2host3: StandardHost {
            @display("p=1377.4651,1307.3651");
        }
        area2switch2: EtherSwitch {
            @display("p=1659.6176,1055.005");
        }
        area3subnet2host1: WirelessHost {
            @display("p=2080.2175,117.4175");
        }
        area3subnet2host2: WirelessHost {
            @display("p=2197.635,212.0525");
        }
        area3subnet2host3: WirelessHost {
            @display("p=2216.9126,336.48");
        }
        area3AP: AccessPoint {
            @display("p=1878.68,346.99503");
        }
        area1router: Router {
            @display("p=1051.5,502.96753");
        }
        area2router: Router {
            @display("p=1309.1176,914.80505");
        }
        area3router: Router {
            @display("p=1591.27,483.69003");
        }
        Backbonerouter: Router {
            @display("p=1309.1176,686.98004;i=abstract/router2");
        }
        configurator: IPv4NetworkConfigurator {
            @display("p=124.427505,89.3775");
        }
        visualizer: IntegratedCanvasVisualizer {
            @display("p=124.427505,282.15253");
        }
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=94.05,467.115");
        }
        standardHost: StandardHost {
            @display("p=799.425,827.64");
        }
        standardHost1: StandardHost {
            @display("p=1724.25,219.45");
        }
    connections:
        area2subnet1host1.ethg++ <--> Eth100M <--> area2switch1.ethg++;
        area2subnet1host2.ethg++ <--> Eth100M <--> area2switch1.ethg++;
        area2subnet1host3.ethg++ <--> Eth100M <--> area2switch1.ethg++;
        area1switch1.ethg++ <--> Eth100M <--> area1subnet1host0.ethg++;
        area1switch1.ethg++ <--> Eth100M <--> area1subnet1host1.ethg++;
        area1switch1.ethg++ <--> Eth100M <--> area1subnet1host2.ethg++;
        area1switch1.ethg++ <--> Eth100M <--> area1router.ethg++;
        area1AP.ethg++ <--> Eth100M <--> area1router.ethg++;
        area1router.ethg++ <--> Eth100M <--> Backbonerouter.ethg++;
        area2switch1.ethg++ <--> Eth100M <--> area2router.ethg++;
        area2router.ethg++ <--> Eth100M <--> area2switch2.ethg++;
        area2switch2.ethg++ <--> Eth100M <--> area2subnet2host1.ethg++;
        area2switch2.ethg++ <--> Eth100M <--> area2subnet2host2.ethg++;
        area2switch2.ethg++ <--> Eth100M <--> area2subnet2host3.ethg++;
        area3switch1.ethg++ <--> Eth100M <--> area3subnet1host1.ethg++;
        area3switch1.ethg++ <--> Eth100M <--> area3subnet1host2.ethg++;
        area3switch1.ethg++ <--> Eth100M <--> area3subnet1host3.ethg++;
        area3switch1.ethg++ <--> Eth100M <--> area3router.ethg++;
        area3router.ethg++ <--> Eth100M <--> area3AP.ethg++;
        area3router.ethg++ <--> Eth100M <--> Backbonerouter.ethg++;
        area2router.ethg++ <--> Eth100M <--> Backbonerouter.ethg++;
        standardHost.ethg++ <--> Eth100M <--> area1AP.ethg++;
        area3AP.ethg++ <--> Eth100M <--> standardHost1.ethg++;
}
