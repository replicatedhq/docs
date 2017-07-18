+++
date = "2017-06-16T00:00:00Z"
title = "Kubernetes"
description = "Packaging a Kubernetes application in Replicated"
weight = "218"
categories = [ "Packaging" ]
aliases = [
    "/kb/developer-resources/kubernetes-prerelease/"
]

[menu.main]
Name       = "Replicated on Kubernetes"
identifier = "kubernetes"
parent     = "/packaging-an-application"
url        = "/docs/packaging-an-application/kubernetes"
+++

If your application is defined as a set of Kubernetes resources, and your customer can run a Kubernetes cluster, Replicated can provide the same standard functionality but on top of a Kubernetes cluster. To see a full example, check out the [Guestbook example](/examples/kubernetes-guestbook).

## Differences from the Replicated scheduler
Unlike the standard Replicated scheduler, when shipping a Kubernetes application on Replicated, it's expected that your customer will supply and maintain the cluster. Replicated is an application that runs on top of the cluster, and does not provide cluster management support.

Some of the standard Replicated features operate differently or are not supported on Kubernetes:

### Replicated Private Images
Images stored in the [Replicated private registry](/getting-started/replicated-private-registry) can be accessed by adding a static `imagePullSecret` to any container definition that references a private image. Replicated will automatically create a secret named `replicatedregistrykey` and deploy it with your application. Refererencing this secret will make your private images available on the target cluster.

### External Private Images
External private images are not supported currently. Replicated hosts a [private registry](/getting-started/replicated-private-registry) that you can use to ship private images. Replicated also supports public (unauthenticated) images in any registry.

### Replicated Auto Updates
Replicated auto updates work as expected when running in Kubernetes. While the Replicated update is applying, the UI will not be available. Once it finishes, refresh the UI to get the update.

### Snapshots
Standard Replicated snapshots are not supported when running in Kubernetes. This functionality will be included in an upcoming release.

### Preflight Checks
There is limited support for preflight checks as of {{< version version="2.9.0" >}}. See the [Kubernetes Preflight Checks](/packaging-an-application/preflight-checks-k8s) section of the docs for more details. Additional support will be available in a future release.

### Admin Commands
Admin commands are supported on Kubernetes. Replicated uses Kubernetes selectors to identify the target pod in which to run the admin command. If multiple pods match the selector then replicated will choose a random pod in which to run the command. Specifying a container is optional as well. If no container is specified the first in the container in the pod will be chosen. See below for an example command.

```yaml
admin_commands:
- alias: redis-sadd
  command: [redis-cli, sadd]
  run_type: exec
  selectors:
    app: redis
    tier: backend
    role: master
  container: master # optional, will choose first in pod
```

### Dashboard Metrics
When running Replicated in Kubernetes, the standard statsd endpoint is still running. The only difference here is that the standard CPU and Memory usage graphs will not be available. You can use the [custom metrics](/packaging-an-application/custom-metrics) feature to define you own application-specific metrics to show on the admin console dashboard.

### Ready State/Health Checks
Replicated will consider the application running when all of the Kubernetes resources are running. Different resources types have various methods to determine when they are started.

| **Resource Type** | **Replicated Considers Running When...** |
|-----|----|
| Deployments | Same as [Kubernetes rollout status] (https://kubernetes.io/docs/user-guide/kubectl/kubectl_rollout_status/) |
| Replication Controller | Same as [Kubernetes rollout status](https://kubernetes.io/docs/user-guide/kubectl/kubectl_rollout_status/) |
| Persistent Volume Claim | When the claim is bound |
| Service | When type is set to LoadBalancer, it's running when the IP address is assigned. |
| Ingress | When the LoadBalancer IP is assigned. |
| Pod | Deployed pods are not monitored. The higher level object is. |
| Job | Jobs are not expected to stay running and are not monitored. |

### Template Functions
There are some additional [template functions](/packaging-an-application/template-functions#kubernetes) available when running in Kubernetes.

### Secrets
Replicated supports runtime secrets through the use of [template functions](/packaging-an-application/template-functions/). It is possible to request a secret from the user using a combination of config settings and the `ConfigOption` [template function](/packaging-an-application/template-functions/#configoption). For more information on configuring the replicated settings screen see the [docs](/packaging-an-application/config-screen/) on customizing the Replicated Admin Console settings page. See below for an example of creating a secret in your application.

For example:
```yaml
# kind: replicated
...
config:
- name: auth
  title: Authentication
  items:
  - name: config_username
    title: Username
    type: password
  - name: config_password
    title: Password
    type: password

---
# kind: scheduler-kubernetes
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
  labels:
    app: guestbook
data:
  username: {{repl ConfigOption "config_username" | Base64Encode }}
  password: {{repl ConfigOption "config_password" | Base64Encode }}
```

### Replicated CLI
The Replicated CLI can be run via the `kubectl exec` command. See below for an example of running a Replicated CLI command.

```shell
kubectl exec -it "$(kubectl get pods -l=app=replicated -o=jsonpath='{.items..metadata.name}')" -c replicated -- replicated apps
```

### Advanced Replicated Configuration
Replicated can be deployed into your kubernetes cluster or it can be deployed independently with the following environment variables:

```bash
SCHEDULER_ENGINE=kubernetes
K8S_OVERRIDE_CLUSTER_CONFIG=true
K8S_HOST=https://10.10.10.10
K8S_TLS_INSECURE=true
K8S_USERNAME=admin
K8S_PASSWORD=password
K8S_CLIENT_CERT_DATA="-----BEGIN CERTIFICATE-----…"
K8S_CLIENT_KEY_DATA="-----BEGIN RSA PRIVATE KEY-----…"
K8S_CLUSTER_CA_CERT_DATA="-----BEGIN CERTIFICATE-----"
```

### Load Balancers and Ingress
Only some environments (typically cloud providers) have support for the Service resource type `LoadBalancer`. An Ingress resource is recommended for more broad support for allowing inbound connections to the cluster. Replicated does not provide an Ingress controller and therefore one must be included in your application yaml. For more details on Ingress see [https://kubernetes.io/docs/user-guide/ingress/](https://kubernetes.io/docs/user-guide/ingress/).
