+++
date = "2017-03-17T00:00:00Z"
lastmod = "2017-03-17T00:00:00Z"
title = "Devicemapper Warning"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

Running devicemapper in loopback mode is discouraged for production. It has known performance problems and a different storage driver should be used.  See [devicemapper performance considerations](https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#other-device-mapper-performance-considerations) and [selecting a storage driver](https://docs.docker.com/engine/userguide/storagedriver/selectadriver/). 

For hosts running Linux kernel 3.17 and under consider upgrading the kernel or moving to [devicemapper with direct-lvm](https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#configure-direct-lvm-mode-for-production) which is Docker's recommended devicemapper configuration for production.

Hosts with Linux kernel 3.18 and above consider moving to overlay but be aware that overlay uses a lot of inodes and so you should create a volume that has a high number of inodes and monitor the volume. See [overlay and docker performance](https://docs.docker.com/engine/userguide/storagedriver/overlayfs-driver/#overlayfs-and-docker-performance) for notes on inode limits and best practices.

Hosts with Docker 1.12 and Linux kernel 4.0 use overlay2 which overcomes the inode issue. As of Docker 1.13 an overlay driver is installed as the preferred storage driver.

To bypass the warning add a `bypass-storagedriver-warnings` flag when running the replicated or operator install scripts. For example

```bash
curl -sSL https://get.replicated.com/docker > install
cat install | sudo bash -s bypass-storagedriver-warnings
```
