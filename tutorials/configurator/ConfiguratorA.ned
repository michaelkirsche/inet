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
import inet.node.ethernet.Eth10M;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;


network ConfiguratorA
{
    @display("bgb=1610.5125,874.96497");
    submodules:
        configurator: IPv4NetworkConfigurator {
            @display("p=100,100");
        }
        host0: StandardHost {
            @display("p=179.48,352.55");
        }
        host1: StandardHost {
            @display("p=179.48,520.8125");
        }
        host2: StandardHost {
            @display("p=179.48,693.88245");
        }
        host3: StandardHost {
            @display("p=536.83746,99.354996");
        }
        router0: Router {
            @display("p=578.5025,576.89996");
        }
        router2: Router {
            @display("p=882.9775,576.89996");
        }
        router1: Router {
            @display("p=730.74,370.1775");
        }
        host4: StandardHost {
            @display("p=778.81494,99.354996");
        }
        host5: StandardHost {
            @display("p=977.52496,99.354996");
        }
        host6: StandardHost {
            @display("p=1249.95,370.1775");
        }
        host7: StandardHost {
            @display("p=1272.3849,549.6575");
        }
        host8: StandardHost {
            @display("p=1261.1675,737.14996");
        }
        switch0: EtherSwitch {
            @display("p=427.8675,575.2975");
        }
        switch1: EtherSwitch {
            @display("p=1072.0725,575.2975");
        }
        switch2: EtherSwitch {
            @display("p=730.74,227.555");
        }
    connections:
        host2.ethg++ <--> Eth100M <--> switch0.ethg++;
        host1.ethg++ <--> Eth100M <--> switch0.ethg++;
        host0.ethg++ <--> Eth100M <--> switch0.ethg++;
        switch0.ethg++ <--> Eth100M <--> router0.ethg++;
        router0.ethg++ <--> Eth100M <--> router1.ethg++;
        router1.ethg++ <--> Eth100M <--> switch2.ethg++;
        switch2.ethg++ <--> Eth100M <--> host3.ethg++;
        switch2.ethg++ <--> Eth100M <--> host4.ethg++;
        switch2.ethg++ <--> Eth100M <--> host5.ethg++;
        router1.ethg++ <--> Eth100M <--> router2.ethg++;
        router2.ethg++ <--> Eth100M <--> switch1.ethg++;
        switch1.ethg++ <--> Eth100M <--> host6.ethg++;
        switch1.ethg++ <--> Eth100M <--> host7.ethg++;
        switch1.ethg++ <--> Eth100M <--> host8.ethg++;
        router0.ethg++ <--> Eth10M <--> router2.ethg++;
}

//##### (marker for doxygen)