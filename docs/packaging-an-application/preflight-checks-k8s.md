+++
date = "2016-07-03T04:02:20Z"
title = "Kubernetes Preflight Checks"
description = "A guide to implementing the Kubernetes Preflight Checks feature to analyze customer systems to determine if the environment meets the minimum requirements for installation or update."
weight = "213"
categories = [ "Packaging" ]
+++

There is limited support for Kubernetes preflight checks as of {{< version version="2.9.0" >}}. Additional support will be available in a future release.

By default, Replicated automatically adds preflight checks for:

| **Category** | **Check** |
|--------------|-----------|
| Outbound internet access (if required) | Replicated APIs, external registries |

Additionally, it's recommended to specify additional system requirements in the `kubernetes` section of the application YAML.

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

### Notes:

- `server_version` must be specified as a semver range
