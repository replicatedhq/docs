+++
date = "2017-03-16T00:00:00Z"
title = "Installing Replicated on Kubernetes"
description = "Instructions for installing Replicated on a Kubernetes cluster."
keywords= "installing, kubernetes"
+++

We distribute standard Kubernetes YAML that can be used to install Replicated onto an existing Kubernetes cluster.

### Basic Install

Download and save the YAML to a file and then use `kubectl` to create it on your cluster.

```shell
curl -sSL -o replicated.yml https://get.replicated.com/kubernetes.yml
kubectl apply -f replicated.yml
```

Quick install:

```shell
kubectl apply -f https://get.replicated.com/kubernetes.yml
```

## Prerequisites
The Kubernetes cluster must already be provisioned.

### Volumes
Replicated requires two persistent volumes on the cluster named `replicated-pv` and `replicated-statsd-pv` with a minimum size of 10GB. 

If you are running Replicated on GKE, you can do this with the following commands:

```bash
gcloud compute disks create --size=10GB --zone=<zone> replicated-pv
gcloud compute disks create --size=10GB --zone=<zone> replicated-statsd-pv
```

