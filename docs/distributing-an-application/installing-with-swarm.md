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

Save the Docker Compose yaml to a file and run. We recommend reading and understanding the Compose file prior to running.

```shell
curl -sSL -o docker-compose.yml https://get.replicated.com/docker-compose.yml
docker stack deploy -c docker-compose.yml
```

Quick install:

```shell
curl -sSL https://get.replicated.com/swarm-init | sudo bash
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
$ sudo docker service ls
```

Using that output, run:

```shell
$ sudo docker service rm <service_name>
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
$ sudo docker ps
```

for each container which is related to the Replicated onprem installation, run:

```shell
$ sudo docker rm <container_id>
```

__Secrets__

```shell
$ sudo docker secret ls
```

for each secret which is related to the Replicated onprem installation, run:

```shell
$ sudo docker secret rm <secret_name>
```

__Volumes__

```shell
$ sudo docker volume ls
```

for each volume which is related to the Replicated onprem installation, run:

```shell
$ sudo docker volume rm <volume_name>
```