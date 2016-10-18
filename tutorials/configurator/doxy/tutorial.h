/**
@mainpage IPv4Configurator Tutorial for the INET Framework

This tutorial will show how to use the <tt>IPv4NetworkConfigurator</tt> module to configure IP addresses and routing tables in wired and wireless IPv4 networks in the INET framework.
The tutorial is organized into multiple steps, each corresponding to a simulation model. The steps demonstrate how to accomplish certain
tasks with the configurator.

This is an advanced tutorial, and assumes that the reader is familiar with creating and running simulations in @opp and INET. If that wasn't the case,
the <a href="https://omnetpp.org/doc/omnetpp/tictoc-tutorial/"
target="_blank">TicToc Tutorial</a> is a good starting point to get familiar with @opp. The <a
href="../../../doc/walkthrough/tutorial.html" target="_blank">INET Walkthrough</a> is an introduction to INET and how to work with protocols.
The <a href="https://omnetpp.org/doc/inet/api-current/tutorials/wireless/" target="_blank">Wireless Tutorial</a> is another advanced tutorial, and deals with wireless features of the INET framework. There is a comprehensive description of the configurator's features in the <a href="https://omnetpp.org/doc/inet/api-current/neddoc/index.html?p=inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator.html" target="_blank"><tt>IPv4NetworkConfigurator</tt> NED documentation</a>
in the INET reference.

For additional information, the following documentation should be useful:

- <a href="https://omnetpp.org/doc/omnetpp/manual/usman.html" target="_blank">@opp User Manual</a>
- <a href="https://omnetpp.org/doc/omnetpp/api/index.html" target="_blank">@opp API Reference</a>
- <a href="https://omnetpp.org/doc/inet/api-current/inet-manual-draft.pdf" target="_blank">INET Manual draft</a>
- <a href="https://omnetpp.org/doc/inet/api-current/neddoc/index.html" target="_blank">INET Reference</a>

All simulation models are defined in the omnetpp.ini file as separate configurations. The configurations use a number of different networks,
defined in separate .NED files.

@section contents Contents

 - @ref step1
 - @ref step2
 - @ref step3

@nav{index,step1}

<!-------------------------------------------------------------------------------------------------------->

@page step1 Step 1 - Fully automatic IP address assignment

@section s1goals Goals

The goal of this step is to demonstrate that in many scenarios, the configurator can adequatelly configure the network with its default settings, without
any user input. This is useful when it is irrelevant what the nodes' actual IP addresses are in a simulation, because the goal is to study wireless
transmission ranges, for example.
In this step, we will show that the configurator's automatic IP address assignment is adequate for the example network
(this step deals with IP addresses only, routing will be discussed in later steps).

@section s1model The model

@subsection s1about  About the configurator

In INET simulations, configurator modules are responsible for assigning IP addresses to network nodes, and for setting up their
routing tables. Essentially, the configurator modules simulate a real life network administrator. There are various configurator
models in INET (<tt>IPv4NetworkConfigurator</tt>, <tt>FlatNetworkConfigurator</tt>, etc.), but this tutorial is about the features of the <tt>IPv4NetworkConfigurator</tt>, 
which we will refer to as <strong>configurator</strong>. The following is a broad review of the configurator's features and operation,
these and others will be discussed in detail in the following steps.

The configurator assigns IP addresses to interfaces, and sets up static routing in IPv4 networks.
It doesn't configure IP addresses and routes directly, but stores the configuration in its internal data structures.
Network nodes contain an instance of <tt>IPv4NodeConfigurator</tt>, which configures the corresponding node's interface table and routing table
based on information contained in the global <tt>IPv4NetworkConfigurator</tt> module.

The configurator supports automatic and manual network configuration, and their combination. By default,
the configuration is fully automatic, but the user can specify parts (or all) of the configuration manually, and the rest
will be configured automatically by the configurator. The configurator's various features can be turned on and off with NED parameters, and the details of the configuration can be specified in an xml configuration file.

@subsection s1configuration The configuration

The configuration for this step uses the <i>ConfiguratorA</i> network, defined in <i>ConfiguratorA.ned</i>.
Here is the NED source for that network:

@dontinclude ConfiguratorA.ned
@skipline ConfiguratorA
@until ####

The network looks like this:

<img src="step1network.png">

The network contains 3 routers, each connected to the other two. There are 3 subnetworks with <tt>standardHosts</tt>, connected to the routers by ethernet switches.
It also contains an instance of <tt>IPv4NetworkConfigurator</tt>.

The ini file:

@dontinclude omnetpp.ini
@skip Step1
@until ####

<! THIS ONE SHOULD BE IN A LATER STEP - The line in the general configuration keeps the routingTable from adding netmask routes that come from interfaces. Since these routes are added by the configurator as well, to keep things simpler,
we instruct the routingTable not to add any routes. This is added to the general configuration so it applies to the config of all steps.>
<!TODO: more on this - how does it work?>
The configuration for Step 1 is empty. The configurator configures addresses according to the default configuration.

@section Results

<!TODO rewrite - draft>
The IP addresses assigned to interfaces by the configurator are shown on the image below.
The addresses are from the 10.0.0.0/29 range, and all nodes are on the same subnet. Adequate for basic networking.

<img src="step1addresses.png" width=850px>

@nav{index,step2}
@fixupini

@page step2 Step 2 - Manually overriding individual IP addresses

@nav{step1,step3}

*/