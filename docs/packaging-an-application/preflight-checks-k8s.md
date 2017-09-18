+++
date = "2016-07-03T04:02:20Z"
title = "Kubernetes Preflight Checks"
description = "A guide to implementing the Kubernetes Preflight Checks feature to analyze customer systems to determine if the environment meets the minimum requirements for installation or update."
weight = "213"
categories = [ "Packaging" ]
+++

Support for Kubernetes preflight checks has been added as of Replicated {{< version version="2.9.0" >}}.

By default, Replicated automatically adds preflight checks for:

| **Category** | **Check** |
|--------------|-----------|
| Outbound internet access (if required) | Replicated APIs, external registries |

Additional Kubernetes system requirements can be specified in the `kubernetes.requirements` section of the application YAML.

Possible checks include:

| **Property** | **Check** |
|--------------|-----------|
| server_version | Kubernetes server version (must be specified as a semver range) |
| api_versions | Supported API versions on the server (in the form of "group/version") |
| cluster_size | Minumum cluster size (nodes) |
| total_cores | Minumum total cores |
| total_memory | Minumum total memory |

### Example:

```yaml
kubernetes:
  requirements:
    server_version: ">=1.6.0"
    api_versions: ["apps/v1beta1"]
    cluster_size: 3
    total_cores: 3
    total_memory: 11.25GB
```

## Custom Preflight Checks

As of 2.11.0, Replicated supports custom preflight checks on the scheduler. To define a custom preflight check, create a `custom_requirements` section in the Replicated spec:

```yaml
custom_requirements:
- id: license-file-exists
  message: License file exists
  details: The vendor license file must exist on the host at /etc/vendor-license
  results:
  - status: success
    message: File /etc/vendor-license exists.
    condition:
      status_code: 0
  - status: error
    message: File /etc/vendor-license does not exists.
    condition:
      status_code: 1
  command:
    id: pod
    data:
      kubernetes:
        pod_name: vendor-license
        global: true
```

In this example, we define a pod name of `vendor-license`, which we must also define as part of the full YAML spec. Preflight Kubernetes pods are defined by prepending `#kind: preflight-kubernetes` to each preflight Kubernetes resource definition, for example:

```yaml
# kind: preflight-kubernetes
apiVersion: v1
kind: Pod
metadata:
  name: vendor-license
spec:
  - image: ubuntu:trusty
    command: ["echo"]
    args: ["Hello World"]
```

## Node Targeting

Custom preflight checks can be targeted using node labels and node affinities. To target a pod for a custom preflight check, use the `nodeSelector` key in the command data:

```yaml
command:
  id: pod
  data:
    kubernetes:
      pod_name: vendor-license
      nodeSelector: database
```

## Run Globally

Sometimes, it can be valuable to run a preflight check on every node. To do so, set `global: true`:

```yaml
command:
  id: pod
  data:
    kubernetes:
      pod_name: check-disk-space
      global: true
```

If `global` is set to false, a single instance of the pod is scheduled in the cluster. This can be useful for performing preflight checks on cluster-level information.
