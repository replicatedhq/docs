+++
date = "2017-03-17T00:00:00Z"
lastmod = "2017-03-17T00:00:00Z"
title = "Devicemapper Warning"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

Running devicemapper in loopback mode is discouraged for production. It has known performance problems and a different storage driver should be used.  See [devicemapper performance considerations](https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#other-device-mapper-performance-considerations) and [selecting a storage driver](https://docs.docker.com/engine/userguide/storagedriver/selectadriver/). As of Docker 1.13 OverlayFS is installed as the preferred Driver.

For Replicated 2.5+ where the host is using IPv4 you can use Docker 1.13.1 which should install an improved storage driver. You can install Docker 1.13.1 prior to running the Replicated daemon or install script using

```bash
curl -sSL https://get.replicated.com/docker > install
cat install | sudo bash -s install-docker-only docker-version=1.13.1
```

To bypass the warning completely (for example in automation scripts for CI/CD pipelines) add the `bypass-storagedriver-warnings` flag when running the replicated or operator install scripts.

```bash
curl -sSL https://get.replicated.com/docker > install
cat install | sudo bash -s bypass-storagedriver-warnings
```

