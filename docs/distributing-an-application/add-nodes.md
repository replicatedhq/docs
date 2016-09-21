+++
date = "2016-07-03T04:02:20Z"
title = "Add Nodes"
description = "When an application is configured by the vendor with a clustering strategy, Replicated makes it possible for the end customer to install additional nodes on remote instances to run a distributed application."
weight = "308"
categories = [ "Distributing" ]

[menu.main]
Name       = "Add Nodes"
identifier = "add-nodes"
parent     = "/distributing-an-application"
url        = "/docs/distributing-an-application/add-nodes"
+++

When an application is configured by the vendor with a clustering strategy, Replicated makes it possible for the end customer to install additional nodes on remote instances to run a distributed application. Installations of Replicated using the [easy installation script](/docs/distributing-an-application/installing/#easy-installation) will install an operator on the local node automatically.

On the Cluster page on the On-Prem Console an "Add Node" button will be visible. This will prompt the end customer with two simple options for adding a node.

## Scripted Installation
The scripted install is the recommended means for adding an additional node to Replicated. The end customer will be prompted for the private and optionally the public address of the server.

![Add Node Script](/static/add-node-script.png)

## Docker Installation
If a scripted install is not possible, additionally a docker script is provided for installing additional nodes.

![Add Node Docker](/static/add-node-docker.png)
