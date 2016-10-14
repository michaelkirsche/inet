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
import inet.node.aodv.AODVRouter;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import inet.visualizer.integrated.IntegratedCanvasVisualizer;


network ConfiguratorE
{
    @display("bgb=1013,653");
    submodules:
        aodvRouter: AODVRouter {
            @display("p=307.47598,274.626");
        }
        aodvRouter1: AODVRouter {
            @display("p=495.378,329.814");
        }
        aodvRouter2: AODVRouter {
            @display("p=399.456,170.81999");
        }
        aodvRouter3: AODVRouter {
            @display("p=625.464,211.554");
        }
        aodvRouter4: AODVRouter {
            @display("p=741.096,363.978;b=7,5");
        }
        aodvRouter5: AODVRouter {
            @display("p=596.55597,469.098");
        }
        aodvRouter6: AODVRouter {
            @display("p=366.606,417.852");
        }
        configurator: IPv4NetworkConfigurator {
            @display("p=59,58");
        }
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=69,145");
        }
        visualizer: IntegratedCanvasVisualizer {
            @display("p=77,233");
        }
}
