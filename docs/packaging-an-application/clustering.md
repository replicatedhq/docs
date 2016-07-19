+++
date = "2016-07-03T04:02:20Z"
title = "Clustering"
description = "An implementation guide for using the Replicated built in clustering functionality."
weight = "208"
categories = [ "Packaging" ]

[menu.main]
Name       = "Clustering"
identifier = "clustering"
parent     = "/packaging-an-application"
url        = "/docs/packaging-an-application/clustering"
+++

By default our application will start one instance per component and container on a single host. With the addition of clustering we can
optionally leverage multiple hosts as well as multiple instances per host.

*See a example of setting up a Cassandra Cluster with Replicated [here](/kb/developer-resources/multi-node-cassandra/)*

## Host Count
At the component level we can scale our app horizontally by specifying host counts using the `cluster_host_count property`. The `cluster`
property is required to enable this feature. When clustering is enabled, all containers that are members of the respective component will
be allocated across the cluster to a minimum of `min` nodes and a maximum of `max` or `-1` for unlimited.
```yml
components:
- name: App
  cluster: true
  cluster_host_count:
    min: 2
    max: 4
  ...
```

In the example above, a minimum of 2 hosts will be required for the application to start. Replicated will start a single instance for each
container that is a member of the App component on a minimum of 2 (and up to 4 hosts) as nodes are added to the cluster.

## Tags
In addition to specifying counts, we can also tag our components with the tags property. The customer will then tag their cluster nodes with
corresponding tags. This will allow the customer to orchestrate where each component of your application will end up across their cluster,
allowing them to best allocate host resources to your application. We can also specify conflicting tags with the conflicts property. Replicated
will prevent conflicting components from being allocated on the same node.

```yml
components:
- name: App
  tags:
  - app
  conflicts:
  - lb
  cluster: true
  ...
```

## Instance Count
We can vertically scale our application on a single host at the container level by specifying instance counts using the cluster_instance_count property.
The cluster property is required to enable this feature.

```yml
components:
- name: App
  ...
  cluster_host_count:
    min: 2
  containers:
  - source: public
    image_name: freighter/worker
    ...
    cluster: true
    cluster_instance_count:
      initial: 3
```

In the example above we will require at least 2 hosts. We will start 3 instances of the freighter/worker container on each of these 2 hosts.
