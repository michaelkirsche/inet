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
import inet.node.ethernet.Eth1G;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.AdhocHost;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import inet.node.inet.WirelessHost;
import inet.node.internetcloud.InternetCloud;
import inet.node.wireless.AccessPoint;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import inet.visualizer.integrated.IntegratedCanvasVisualizer;


network ConfiguratorG
{
    @display("bgb=1342,781");
    submodules:
        Area1AP: AccessPoint {
            @display("p=169,624");
        }
        Area1Switch: EtherSwitch {
            @display("p=385,624");
        }
        Area1Router: Router {
            @display("p=276,526");
        }
        Area2Router: Router {
            @display("p=716,522");
        }
        Area3AP: AccessPoint {
            @display("p=895,315");
        }
        Area2Switch1: EtherSwitch {
            @display("p=661,615");
        }
        Area2Switch2: EtherSwitch {
            @display("p=817,609");
        }
        ISP1Router: Router {
            @display("p=464,390;i=abstract/router2");
        }
        ISP2Router: Router {
            @display("p=694,243");
        }
        BackboneRouter: Router {
            @display("p=464,243;i=abstract/router2");
        }
        Area1WirelessHost1: WirelessHost {
            @display("p=64,655");
        }
        Area1WirelessHost2: WirelessHost {
            @display("p=103,719");
        }
        Area1WirelessHost3: WirelessHost {
            @display("p=223,688");
        }
        Area1Host1: StandardHost {
            @display("p=349,719");
        }
        Area1Host2: StandardHost {
            @display("p=442,710");
        }
        Area2Host1: StandardHost {
            @display("p=591,704");
        }
        Area2Host2: StandardHost {
            @display("p=700,704");
        }
        Area2Host3: StandardHost {
            @display("p=839,705");
        }
        Area2Host4: StandardHost {
            @display("p=936,655");
        }
        Area2Host5: StandardHost {
            @display("p=941,568");
        }
        Area3Host1: StandardHost {
            @display("p=1002,380");
        }
        Area3WirelessHost2: WirelessHost {
            @display("p=1041,284");
        }
        Area3WirelessHost1: WirelessHost {
            @display("p=957,211");
        }
        Area3MobileHost: AdhocHost {
            @display("p=865,408");
        }
        Area1MobileHost: AdhocHost {
            @display("p=82,549");
        }
        Area4Switch: EtherSwitch {
            @display("p=856,143");
        }
        standardHost: StandardHost {
            @display("p=980,49");
        }
        standardHost1: StandardHost {
            @display("p=856,49");
        }
        Area4Host: StandardHost {
            @display("p=755,49");
        }
        Mainframe: StandardHost {
            @display("p=293,144;i=device/mainframe");
        }
        Server1: StandardHost {
            @display("p=228,342;i=device/server");
        }
        Server2: StandardHost {
            @display("p=327,342;i=device/server");
        }
        configurator: IPv4NetworkConfigurator {
            @display("p=100,100");
        }
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=100,200");
        }
        visualizer: IntegratedCanvasVisualizer {
            @display("p=100,300");
        }
    connections:
        Area1AP.ethg++ <--> Eth100M <--> Area1Router.ethg++;
        Area1Switch.ethg++ <--> Eth100M <--> Area1Router.ethg++;
        Area2Switch1.ethg++ <--> Eth100M <--> Area2Router.ethg++;
        Area2Switch2.ethg++ <--> Eth100M <--> Area2Router.ethg++;
        Area1Router.ethg++ <--> Eth100M <--> ISP1Router.ethg++;
        Area2Router.ethg++ <--> Eth100M <--> ISP1Router.ethg++;
        ISP1Router.ethg++ <--> Eth100M <--> BackboneRouter.ethg++;
        BackboneRouter.ethg++ <--> Eth100M <--> ISP2Router.ethg++;
        Area3Host1.ethg++ <--> Eth100M <--> Area3AP.ethg++;
        Area2Switch2.ethg++ <--> Eth100M <--> Area2Host5.ethg++;
        Area2Switch2.ethg++ <--> Eth100M <--> Area2Host4.ethg++;
        Area2Switch2.ethg++ <--> Eth100M <--> Area2Host3.ethg++;
        Area2Host2.ethg++ <--> Eth100M <--> Area2Switch1.ethg++;
        Area2Host1.ethg++ <--> Eth100M <--> Area2Switch1.ethg++;
        Area1Host2.ethg++ <--> Eth100M <--> Area1Switch.ethg++;
        Area1Host1.ethg++ <--> Eth100M <--> Area1Switch.ethg++;
        BackboneRouter.ethg++ <--> Eth1G <--> Mainframe.ethg++;
        Server2.ethg++ <--> Eth1G <--> BackboneRouter.ethg++;
        Server1.ethg++ <--> Eth1G <--> BackboneRouter.ethg++;
        Area3AP.ethg++ <--> Eth100M <--> ISP2Router.ethg++;
        Area4Switch.ethg++ <--> Eth100M <--> ISP2Router.ethg++;
        Area4Switch.ethg++ <--> Eth100M <--> Area4Host.ethg++;
        Area4Switch.ethg++ <--> Eth100M <--> standardHost1.ethg++;
        Area4Switch.ethg++ <--> Eth100M <--> standardHost.ethg++;
}
