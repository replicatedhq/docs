+++
date = "2016-07-03T04:02:20Z"
title = "Add Nodes"
description = "If an application is configured by the vendor with tags and a clustering strategy, Replicated provides several simple options for end customers to scale the application to multiple nodes."
weight = "308"
categories = [ "Distributing" ]

[menu.main]
Name       = "Add Nodes"
identifier = "add-nodes"
parent     = "/distributing-an-application"
url        = "/docs/distributing-an-application/add-nodes"
+++

All installations of Replicated should install the first node automatically.  But it's
possible to install additional nodes and run a distributed app.

![Add Node](/static/add-host.png)

## Scripted Install
This is a new feature that allows your customers to run a curl script on additional hosts to have them
automatically connect into the primary Replicated management machine. V1 of manual installation requires
that they install the agent from the internet, but future versions will allow them to install the agent
from the Replicated daemon.

![Add Node Modal](/static/add-host-modal.png)

## Docker Install

## Local Install
In most instances this will be grayed out because Replicated automatically installs an agent on the local
machine if the interface was identified during initial installation. However, if no interface was initially
available, your customer will be able to use this path to install it.

![Add Node Locally](/static/add-host-local.png)
