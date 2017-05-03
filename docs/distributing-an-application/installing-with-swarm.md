+++
date = "2017-04-11T00:00:00Z"
title = "Installing Replicated with Docker Swarm"
description = "Instructions for installing Replicated with a Swarm cluster"
keywords= "installing, swarm"
aliases = [
    "/distributing-an-application/installing-on-swarm/"
]
+++

We distribute an installation script that can be used to install Replicated into a new or existing Swarm cluster. The cluster does not have to be created at this point, the Replicated install script can install Docker Engine and provision a new Swarm cluster.

### Basic install (recommended):

The basic install will install Docker (as needed) and Replicated. It will save the install script to a file which you can inspect and then run. We recommend reading and understanding the install script prior to running.


```shell
curl -sSL -o install.sh  https://get.replicated.com/swarm-init
sudo bash ./install.sh
```

### Quick Install:  

The quick Swarm install will install Docker (as needed) and Replicated. Use this method if you have no need to view/change the installer script and you just want a one-line install.

```shell
curl -sSL https://get.replicated.com/swarm-init | sudo bash
```

#### Flags:
The install script can take flags to help your customers with specialized enterprise setups.

|Flag|Usage|
|----|-----|
|airgap|arigap implies "no proxy" and "skip docker"|
|bypass-storagedriver-warnings|Bypass the storagedriver warning|
|daemon-token|Authentication token used by operators for automating a cluster installation|
|docker-version|Install a specific version of docker|
|http-proxy|If present, then use proxy|
|log-level|If present, this will be the log level of the Replicated daemon (debug, info, or error).|
|no-docker|Skip docker installation|
|no-proxy|If present, do not use a proxy|
|public-address|The public IP address for stack|
|swarm-advertise-addr|The swarm advertise address|
|swarm-listen-addr|The swarm listen address|
|swarm-stack-namespace|The swarm stack namespace to use|
|ui-bind-port|The port to bind the UI to|

Example quick install with flags:
```shell
curl -sSL https://get.replicated.com/swarm-init | sudo bash -s no-proxy ui-bind-port=8000
```

### Advanced Install:

The advanced Swarm install requires the host is running Docker with a version between {{< swarm_docker_version_minimum >}} - {{< swarm_docker_version_default >}}.

This method will save the Docker Compose YAML to a file and then run a command using the YAML file as the input. We recommend reading and understanding the Compose file prior to running.

```shell
curl -sSL -o docker-compose.yml https://get.replicated.com/docker-compose.yml
docker stack deploy -c docker-compose.yml replicated
```

## Installing Behind A Proxy

Proxy support for Swarm will be included in a future release of Replicated.
