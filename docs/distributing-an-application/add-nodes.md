+++
date = "2016-07-03T04:02:20Z"
title = "Add Nodes"
description = "When a Replicated-orchestrated application is configured with a clustering strategy, additional nodes can be installed on remote instances to take part in the cluster."
weight = "307"
categories = [ "Distributing" ]

[menu.main]
Name       = "Add Nodes"
identifier = "add-nodes"
parent     = "/distributing-an-application"
url        = "/docs/distributing-an-application/add-nodes"
+++

The instructions to add additional nodes are different depending the running scheduler.

### Replicated Scheduler
To add additional nodes when running on the Replicatd schdduler, refer to the instructions on the /cluster page of the Admin Console. For details, visit the [instructions for adding additional Replicated nodes](/distributing-an-application/add-nodes-replicated).

### Swarm Scheduler
To add additional nodes when running on the Swarm scheduler, refer to the instructions on the /cluster page of the Admin Console. For details, visit the [instructions for adding additional Swarm nodes](/distributing-an-application/add-nodes-swarm).

## Airgapped Installations
When adding a node in an airgapped installation, each node will require that Docker is already installed. When adding a node via the easy installation method, the easy install script must be copied to the operator node manually. The script can be found in the Replicated [airgap archive](/distributing-an-application/airgapped-installations/#install-replicated).
