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
|airgap|airgap implies "no proxy" and "skip docker"|
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
docker swarm init
curl -sSL -o docker-compose.yml "https://get.replicated.com/docker-compose.yml?swarm_node_address=$(docker info --format '{{.Swarm.NodeAddr}}')"
docker node update --label-add replicated-role=master "$(docker info --format '{{.Swarm.NodeID}}')"
export LC_CTYPE=C;echo "$(head -c 128 /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)" | docker secret create daemon_token -
docker stack deploy -c docker-compose.yml replicated
```

### Installing Behind A Proxy

Proxy support for Swarm will be included in a future release of Replicated.

### Uninstall

__Stacks__


```shell
$ docker stack ls
```

Using that output, run:

```shell
$ docker stack rm <stack_name>
```

for each stack with `replicated` in the name. Some portions of the stack deletion might fail, we will get back to those.

__Services__

```shell
$ docker service ls
```

Using that output, run:

```shell
$ docker service rm <service_name>
```

for each service with `premkit`, `statsd`, or `replicated` in the name.

__Stacks Again__

```shell
$ docker stack ls
```

Using that output, run:

```shell
$ docker stack rm <stack_name>
```

for each stack with `replicated` in the name.


__Lingering Containers__


```shell
$ docker ps -a
```

for each container which is related to the Replicated onprem installation, run:

```shell
$ docker rm <container_id>
```

__Secrets__

```shell
$ docker secret ls
```

for each secret which is related to the Replicated onprem installation, run:

```shell
$ docker secret rm <secret_name>
```

__Volumes__

```shell
$ docker volume ls
```

for each volume which is related to the Replicated onprem installation, run:

```shell
$ docker volume rm <volume_name>
```