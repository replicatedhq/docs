+++
date = "2016-07-26T00:00:00Z"
lastmod = "2016-09-29T00:00:00Z"
title = "Kubernetes Pre-release"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

A future release of Replicated will support deploying Replicated and your application to a Kubernetes cluster. This is currently available as a pre-release feature, and is not ready to deliver to any production installations.

{{< note title="Pre-Release Version" >}}
The features and the implementation described in this document is subject to change before final release. Any YAML created using this information may not be compatible with the final release.
{{< /note >}}

## Requirements
You should have a standard Kubernetes YAML available to deploy. Replicated expects that the YAML will contain exactly one delpoyment spec (replication controllers are currently unsupported).

## Known Limitations
- Admin commands are not supported
- Snapshots are not supported

## Create a Replicated YAML with Kubernetes 
```yaml
---
# kind: replicated
# apiVersion: 2.3.5
name: Kubernetes Minecraft Demo
version: "alpha-1"
release_notes: The initial release of my Kubernetes Minecraft Demo application.
properties:
  app_url:
    kubernetes:
      value_from:
        services_url:
          name: minecraft
          port: '{{repl ConfigOption "minecraft_port" }}'
          tls: true
config:
- name: service
  title: Service
  description: Service settings
  items:
  - name: minecraft_port
    title: Port
    type: text
    default: "25565"
    required: true

---
# kind: kubernetes
volume_claims:
- name: mc-pv-claim
  storage: 10Gi
  access_modes: ["ReadWriteOnce"]

---
# kind: scheduler-kubernetes
apiVersion: v1
kind: Service
metadata:
  name: minecraft
  labels:
    run: minecraft
spec:
  type: LoadBalancer
  ports:
    - port: {{repl ConfigOption "minecraft_port" }}
      targetPort: 25565
  selector:
    run: minecraft
    tier: server
---
# kind: scheduler-kubernetes
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mc-pv-claim
  labels:
    run: minecraft
    tier: server
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
# kind: scheduler-kubernetes
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: minecraft
spec:
  replicas: 1
  template:
    metadata:
      labels:
        run: minecraft
        tier: server
    spec:
      volumes:
      - name: mc-data
        persistentVolumeClaim:
          claimName: mc-pv-claim
      containers:
      - name: mc
        image: itzg/minecraft-server:latest
        ports:
        - containerPort: 25565
        volumeMounts:
        - name: mc-data
          mountPath: /data
        env:
        - name: EULA
          value: "TRUE"
```

## Configure Replicated
Replicated can be deployed into your kubernetes cluster (TODO: documents this) or it can be deployed independently with the following /etc/replicated.conf:
```json
{
        "SchedulerEngine": "kubernetes",
        "K8sOverrideClusterConfig": true,
        "K8sHost": "https://10.10.10.10",
        "K8sUsename": "admin",
        "K8sPassword": "password",
        "K8sClusterCACertData": "<base64 encoded cert>"
}
```

## Install replicated
`curl -sSL https://get.replicated.com/docker | sudo bash`
