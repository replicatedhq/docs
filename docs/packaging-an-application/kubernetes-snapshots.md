+++
date = "2017-08-31T00:00:00Z"
title = "Kubernetes Snapshots"
description = "Application Snapshots in Kubernetes"
weight = "219"
categories = [ "Packaging" ]
aliases = []

[menu.main]
Name       = "Application Snapshots in Kubernetes"
identifier = "kubernetes-snapshosts"
parent     = "/packaging-an-application"
url        = "/docs/packaging-an-application/kubernetes-snapshots"
+++

## Application Snapshots on Kubernetes

Kubernetes Snapshots can be used to back up any kubernetes resources
that use a [Persistent Volume Claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) (PVC)
for persistent storage. In addition to storing your application data in a PVC, you'll need to whitelist it
in your Replicated application yaml's `backup` section. For example, to back up a PVC named 
`redis-data-volume`, use the following `backup` config.

```yml
backup:
  enabled: true
  kubernetes:
    pvc_names: [ "redis-data-volume" ]
```

End-to-end application config for a PVC-backed redis deployment might look something like

```yml
---
# kind: replicated
replicated_api_version: 2.11.0
name: Redis-K8s

host_requirements:
  replicated_version: ">=2.11.0 <=2.12.0"
properties:
  logo_url: https://redis.io/images/redis-white.png
  console_title: Persistent Redis Example
backup:
  enabled: true
  kubernetes:
    pvc_names: [ "redis-data-volume" ]
---
# kind: scheduler-kubernetes
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-data-volume
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  annotations:
    volume.beta.kubernetes.io/storage-class: standard
---
#kind: scheduler-kubernetes
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: redis
spec:
  replicas: 1
  template:
    spec:
      containers:
        - name: redis
          image: redis:3.0
          command: 
            - redis-server
            - --appendonly
            - "yes"
          volumeMounts:
            - name: redis-data
              mountPath: /data
          ports:
            - containerPort: 6379
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: redis-data-volume
```


Check out the [Kubernetes Snapshots Architecture](/packaging-an-application/kubernetes-snapshots) Doc to learn more about how
Replicated manages your Persistent volumes and stores the backed up data.


When installing Replicated, application backup archives will be stored on the
replicated master's PVC by default ("local" mode). This is not reccomended for production deployments, and end users of replicated are encouraged to customize the 
backup implementation in the Replicated Admin Console under "Console Settings" to use either SFTP or Amazon S3 for backup storage.

These parameters can also be configured  by overriding the default configuration and setting
all of either the `sftp` or the `s3` snapshot parameters on the `replicated` deployment in Kubernetes:

For SFTP:
```
SNAPSHOTS_STORE=sftp
SNAPSHOTS_PATH=...
SNAPSHOTS_SFTP_HOST=...
SNAPSHOTS_SFTP_USERNAME=...
SNAPSHOTS_SFTP_PRIVATE_KEY_PEM=...
```
SFTP does not currently support password authentication.

For S3:
```
SNAPSHOTS_STORE=s3
SNAPSHOTS_PATH=...
SNAPSHOTS_S3_BUCKET=...
SNAPSHOTS_AWS_REGION=...
SNAPSHOTS_AWS_KEY_ID=...
SNAPSHOTS_AWS_SECRET_KEY=...
```
.
