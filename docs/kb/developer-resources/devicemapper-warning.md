+++
date = "2017-03-17T00:00:00Z"
lastmod = "2017-03-17T00:00:00Z"
title = "Devicemapper Warning"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

Running devicemapper in loopback mode is discouraged for production. It has known performance problems and a different storage driver should be used.  See [devicemapper performance considerations](https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/#other-device-mapper-performance-considerations) and [selecting a storage driver](https://docs.docker.com/engine/userguide/storagedriver/selectadriver/). As of Docker 1.13 OverlayFS is installed as the preferred Driver.

To bypass the warning add a `bypass-storagedriver-warnings` flag when running the replicated or operator install scripts. For example

```bash
curl -sSL https://get.replicated.com/docker > install
cat install | sudo bash -s bypass-storagedriver-warnings
```
