+++
date = "2017-04-11T00:00:00Z"
title = "Installing Replicated with Docker Swarm"
description = "Instructions for installing Replicated with a Swarm cluster"
keywords= "installing, swarm"
+++

We distribute an installation script that can be used to install Replicated into a new Swarm cluster. The cluster does not have to be created at this point, the Replicated install script will install docker-engine and provision a new swarm cluster.

### Basic Install

Save the install script to a file and run. We recommend reading and understanding the install script prior to running.

```shell
curl -sSL -o install.sh https://get.replicated.com/swarm-init
sudo bash ./install
```

Quick install:

```shell
curl -sSL https://get.replicated.com/swarm-init | sudo bash
```

## Installing Behind A Proxy

