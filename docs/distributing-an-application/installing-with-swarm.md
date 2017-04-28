+++
date = "2017-04-11T00:00:00Z"
title = "Installing Replicated with Docker Swarm"
description = "Instructions for installing Replicated with a Swarm cluster"
keywords= "installing, swarm"
aliases = [
    "/distributing-an-application/installing-on-swarm/"
]
+++

We distribute an installation script that can be used to install Replicated into a new Swarm cluster. The cluster does not have to be created at this point, the Replicated install script will install Docker Engine and provision a new swarm cluster.


### Basic Install

The basic swarm install requires the host is running Docker with a version between  {{< swarm_docker_version_minimum >}} - {{< swarm_docker_version_default >}}.

Save the Docker Compose YAML to a file and run. We recommend reading and understanding the Compose file prior to running.

```shell
curl -sSL -o docker-compose.yml https://get.replicated.com/docker-compose.yml
docker stack deploy -c docker-compose.yml replicated
```

### Easy install:

The easy install will install Docker (as needed) and Replicated.


```shell
curl -sSL https://get.replicated.com/swarm-init | sudo bash
```

## Installing Behind A Proxy

Proxy support for Swarm will be included in a future release of Replicated.

