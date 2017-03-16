+++
date = "2016-07-26T00:00:00Z"
lastmod = "2017-02-24T00:00:00Z"
title = "Kubernetes Pre-release"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

The current release of Replicated supports deploying Replicated and your application to a Kubernetes cluster. This is not yet intended for production installations. Contact the Replicated team to ensure that your account has this feature enabled.

## Requirements

You should have a standard Kubernetes YAML available to deploy. Replicated expects that the YAML will contain at least one deployment spec (replication controllers are currently unsupported, use deployments instead).

## Create a Kubernetes Cluster with two persistent volumes (minimum capacity 10 GB)

### GCE

```bash
$ gcloud compute disks create --size=10GB --zone=<zone> replicated-pv

and

$ gcloud compute disks create --size=10GB --zone=<zone> replicated-statsd-pv
```

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: replicated-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  gcePersistentDisk:
    pdName: replicated-pv
    fsType: ext4
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: replicated-statsd-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  gcePersistentDisk:
    pdName: replicated-statsd-pv
    fsType: ext4
```

### HostPath

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: replicated-pv
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 10Gi
  hostPath:
    path: /data/pv0002/
```

## Install Replicated on the cluster

```bash
kubectl apply -f https://get.replicated.com/kubernetes.yml
```

## Create a sample app by using this Kubernetes YAML with Replicated

```yaml
---
# kind: replicated
replicated_api_version: "2.3.5"
version: "alpha"
name: "Guestbook"
properties:
  app_url: '{{repl ServiceAddress "frontend" 80 }}'
  logo_url: http://www.replicated.com/images/logo.png
  console_title: Guestbook Console

admin_commands:
- alias: redis-cli
  command: [redis-cli]
  run_type: exec
  selectors:
    app: redis
    tier: backend
    role: master
  container: master # optional, will choose first in pod

config:
- name: advanced
  title: Advanced
  items:
  - name: redis_pv_storage_class
    title: Redis PV Storage Class
    type: text
    default: slow

---
# kind: scheduler-kubernetes
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: redis-pvc
  labels:
    app: redis
  annotations:
    volume.alpha.kubernetes.io/storage-class: {{repl ConfigOption "redis_pv_storage_class" }}
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi

---
# kind: scheduler-kubernetes
apiVersion: v1
kind: Service
metadata:
  name: redis-master
  labels:
    app: redis
    tier: backend
    role: master
spec:
  ports:
    # the port that this service should serve on
  - port: 6379
    targetPort: 6379
  selector:
    app: redis
    tier: backend
    role: master

---
# kind: scheduler-kubernetes
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: redis-master
  # these labels can be applied automatically
  # from the labels in the pod template if not set
  # labels:
  #   app: redis
  #   role: master
  #   tier: backend
spec:
  # this replicas value is default
  # modify it according to your case
  replicas: 1
  # selector can be applied automatically
  # from the labels in the pod template if not set
  # selector:
  #   matchLabels:
  #     app: guestbook
  #     role: master
  #     tier: backend
  template:
    metadata:
      labels:
        app: redis
        role: master
        tier: backend
    spec:
      containers:
      - name: master
        image: gcr.io/google_containers/redis:e2e  # or just image: redis
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 6379
        volumeMounts:
        - mountPath: /redis-master-data
          name: data
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: redis-pvc

---
# kind: scheduler-kubernetes
apiVersion: v1
kind: Service
metadata:
  name: redis-slave
  labels:
    app: redis
    tier: backend
    role: slave
spec:
  ports:
    # the port that this service should serve on
  - port: 6379
  selector:
    app: redis
    tier: backend
    role: slave

---
# kind: scheduler-kubernetes
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: redis-slave
  # these labels can be applied automatically
  # from the labels in the pod template if not set
  # labels:
  #   app: redis
  #   role: slave
  #   tier: backend
spec:
  # this replicas value is default
  # modify it according to your case
  replicas: {{repl ConfigOption "redis_slave_replicas" }}
  # selector can be applied automatically
  # from the labels in the pod template if not set
  # selector:
  #   matchLabels:
  #     app: guestbook
  #     role: slave
  #     tier: backend
  template:
    metadata:
      labels:
        app: redis
        role: slave
        tier: backend
    spec:
      containers:
      - name: slave
        image: gcr.io/google_samples/gb-redisslave:v1
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        env:
        - name: GET_HOSTS_FROM
          value: dns
          # If your cluster config does not include a dns service, then to
          # instead access an environment variable to find the master
          # service's host, comment out the 'value: dns' line above, and
          # uncomment the line below.
          # value: env
        ports:
        - containerPort: 6379

---
# kind: scheduler-kubernetes
apiVersion: v1
kind: Service
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # if your cluster supports it, uncomment the following to automatically create
  # an external load-balanced IP for the frontend service.
  type: LoadBalancer
  ports:
    # the port that this service should serve on
  - port: 80
  selector:
    app: guestbook
    tier: frontend

---
# kind: scheduler-kubernetes
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: frontend
  # these labels can be applied automatically
  # from the labels in the pod template if not set
  # labels:
  #   app: guestbook
  #   tier: frontend
spec:
  # this replicas value is default
  # modify it according to your case
  replicas: {{repl ConfigOption "frontend_replicas" }}
  # selector can be applied automatically
  # from the labels in the pod template if not set
  # selector:
  #   matchLabels:
  #     app: guestbook
  #     tier: frontend
  template:
    metadata:
      labels:
        app: guestbook
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google-samples/gb-frontend:v4
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        env:
        - name: GET_HOSTS_FROM
          value: dns
          # If your cluster config does not include a dns service, then to
          # instead access environment variables to find service host
          # info, comment out the 'value: dns' line above, and uncomment the
          # line below.
          # value: env
        ports:
        - containerPort: 80
```

### Load Balancers and Ingress

Only some environments (typically cloud providers) have support for the Service resource type `LoadBalancer`. An Ingress resource is recommended for more broad support for allowing inbound connections to the cluster. Replicated does not provide an Ingress controller and therefore one must be included in your application yaml. For more details on Ingress see [https://kubernetes.io/docs/user-guide/ingress/](https://kubernetes.io/docs/user-guide/ingress/).

## Advanced Replicated Configuration

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
K8S_CLUSTER_CA_CERT_DATA="-----BEGIN CERTIFICATE-----..."
```

## Feature Support

- [x] Admin commands
- [ ] Airgapped installation
- [x] Application state monitoring
- [x] CLI
- [ ] CPU and memory container monitoring
- [x] Config settings
- [x] Custom monitors
- [x] Easy install script
- [x] Integration API
- [x] Licensing
- [ ] On-Prem registry
- [x] Preflight checks (limited)
- [ ] Ready state
- [ ] Replicated snapshots
- [x] Replicated auto-updates
- [x] Support bundle
- [x] Vendor registry

## Vendor Registry

Replicated creates an image pull secret named `replicatedregistrykey` along with your application resources. You can make use of this secret when using the Replicated vendor registry. See the example below for more details.

```yml
    spec:
      containers:
      - name: frontend
        image: registry.replicated.com/guestbook/gb-frontend:v4
        ...
      imagePullSecrets:
      - name: replicatedregistrykey
```

## Secrets

Replicated supports runtime secrets through the use of [template functions](https://www.replicated.com/docs/packaging-an-application/template-functions/). It is possible to request a secret from the user using a combination of config settings and the `ConfigOption` [template function](https://www.replicated.com/docs/packaging-an-application/template-functions/#configoption). For more information on configuring the replicated settings screen see the [docs](https://www.replicated.com/docs/packaging-an-application/config-screen/) on customizing the On-Prem Console settings page. See below for an example of creating a secret in your application.

```yml

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

## CLI

The Replicated CLI can be run via the `kubectl exec` command. See below for an example of running a Replicated CLI command.

```bash
kubectl exec -it "$(kubectl get pods -l=app=replicated -o=jsonpath='{.items..metadata.name}')" -c replicated -- replicated apps
```

## Admin Commands

Admin commands are supported on Kubernetes. Replicated uses Kubernetes selectors to identify the target pod in which to run the admin command. If multiple pods match the selector then replicated will choose a random pod in which to run the command. Specifying a container is optional as well. If no container is specified the first in the pod will be chosen. See below for an example command.

```yml
admin_commands:
- alias: redis-cli
  command: [redis-cli]
  run_type: exec
  selectors:
    app: redis
    tier: backend
    role: master
  container: master # optional, will choose first in pod
```

## Template Functions

Below are additional Kubernetes specific template functions.

### Namespace

```go
func Namespace() string
```

Namespace returns the value of the namespace the vendor application is installed in.

### ServiceAddress

```go
ServiceAddress(name string, port int32) string
```

ServiceAddress returns the address of the ingress.

```yml
properties:
  app_url: '{{repl ServiceAddress "frontend" 80 }}'
```

### IngressAddress

```go
IngressAddress(name string, port int32) string
```

IngressAddress returns the address of the ingress.

```yml
properties:
  app_url: '{{repl IngressAddress "frontend" 80 }}'
```

###  PremkitAPIAddress

```go
PremkitAPIAddress() string
```

PremkitAPIAddress return the address of the Premkit service in the cluster.

```yml
spec:
  containers:
  - name: myservice
    image: mycompany/myservice:1.0
    env:
    - name: REPLICATED_INTEGRATIONAPI
      value: {{repl PremkitAPIAddress }}
```

###  StatsdAddress

```go
StatsdAddress() string
```

StatsdAddress return the address of the Statsd service in the cluster.

```yml
spec:
  containers:
  - name: myservice
    image: mycompany/myservice:1.0
    env:
    - name: REPLICATED_STATSD_ADDRESS
      value: {{repl StatsdAddress }}
```