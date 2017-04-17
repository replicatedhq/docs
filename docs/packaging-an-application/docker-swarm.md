+++
date = "2017-07-11T00:00:00Z"
title = "Docker Swarm"
description = "Packaging a Docker Swarm application in Replicated"
weight = "219"
categories = [ "Packaging" ]

[menu.main]
Name       = "Replicated with Docker Swarm"
identifier = "docker-swarm"
parent     = "/packaging-an-application"
url        = "/docs/packaging-an-application/docker-swarm"
+++

If your application is defined as a Docker Compose version 3 or 3.1 yaml file, Replicated can provide the same standard functionality deploying your application via the [Docker Swarm](https://docs.docker.com/engine/swarm/) scheduler as a [Docker Stack](https://docs.docker.com/docker-cloud/apps/stacks/). Using the Swarm scheduler, you can use all of the Swarm functionality including overlay networks, DNS service discovery, Docker secrets and more. To see a full example, check out the [Voting App example](/examples/swarm-votingapp).

## Differences from the Replicated scheduler

Like the standard Replicated scheduler, when shipping an application using Swarm mode, Replicated provides the same simple cluster management for your customer. Replicated is an application that runs within the Swarm cluster, and will additionally leverage the Docker Swarm API to provide cluster management support.

Some of the standard Replicated features operate differently or are not supported on Swarm:

### External Private Images
External private images are not supported currently. Replicated hosts a [private registry](/getting-started/replicated-private-registry) that you can use to ship private images. Replicated also supports public (unauthenticated) images in any registry.

### Replicated Auto Updates
Replicated auto updates work as expected when running in Swarm mode. While the Replicated update is applying, the UI will not be available. Once it finishes, refresh the UI to get the update.

### Snapshots
Standard Replicated snapshots are not supported when running in Swarm mode. This functionality will be included in an upcoming release.

### Custom Preflight Checks
Custom preflight checks are not currently supported when running in Swarm mode. These will be available in a future release.

### Admin Commands
Admin commands are not supported when running in Swarm mode. This functionality will be included in a future release.

### Dashboard Metrics
When running Replicated in Swarm mode, the standard statsd endpoint is still running. The only difference here is that the standard CPU and Memory usage graphs will not be available and will be included in an upcoming release. You can use the [custom metrics](/packaging-an-application/custom-metrics) feature to define you own application-specific metrics to show on the admin console dashboard.

### Ready State/Health Checks
Replicated will consider the application running when all replicas of the Swarm services are running. Ready state functionality is not currently supported when running in Swarm mode. This functionality will be included in an upcoming release.

### Template Functions
There are some additional [template functions](/packaging-an-application/template-functions#kubernetes) available when running in Swarm mode.

### Secrets
Just like using the native Replicated scheduler, secrets are supported through the combination of [template functions](https://www.replicated.com/docs/packaging-an-application/template-functions/) and environment variables. Additionally your application has the option of using [Swarm secrets](https://docs.docker.com/engine/swarm/secrets/) management. Replicated will add support for Swarm secrets in a future release.

### Replicated CLI
The Replicated CLI can be run via the `docker exec` command. See below for an example of running a Replicated CLI command.

```shell
sudo docker exec -it "$(sudo docker inspect --format "{{.Status.ContainerStatus.ContainerID}}" "$(sudo docker service ps replicated_replicated -q)")" replicated apps
```
