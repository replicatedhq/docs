+++
date = "2016-07-26T00:00:00Z"
lastmod = "2016-09-29T00:00:00Z"
title = "Kubernetes Pre-release"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

A future release of Replicated will support deploying Replicated and your application to a Kubernetes cluster.

## Requirements
You should have a standard Kubernetes YAML available to deploy. Replicated expects that the YAML will contain at least one deployment spec (replication controllers are currently unsupported, use deployments instead).

## Known Limitations
- Replicated admin commands are not yet supported
- Replicated snapshots are not yet supported

## Create a Kubernetes Cluster with a persistent volume (at least 10 gigs)
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
   pdName: replicated-pv-1
   fsType: ext4
```

## Install Replicated on the cluster
Provide this Kubernetes YAML to your customer as well as a `.rli` license file.
```yaml
apiVersion: v1
kind: Service
metadata:
  name: replicated-lb
  labels:
    app: replicated
spec:
  type: LoadBalancer
  selector:
    app: replicated
  ports:
    - port: 8800
      name: repl-ui
---
apiVersion: v1
kind: Service
metadata:
  name: replicated
  labels:
    app: replicated
spec:
  type: ClusterIP
  selector:
    app: replicated
  ports:
    - port: 9874
      name: repl-registry
    - port: 9880
      name: repl-iapi
    - port: 9877
      name: repl-liapi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: replicated-pv-claim
  labels:
    app: replicated
  annotations:
    volume.beta.kubernetes.io/storage-class: ""
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: replicated
  labels:
    app: replicated
    tier: master
spec:
  template:
    metadata:
      labels:
        app: replicated
    spec:
      containers:
      - name: replicated
        image: quay.io/replicated/replicated:stable-2.3.2
        imagePullPolicy: Always
        env:
        - name: SCHEDULER_ENGINE
          value: kubernetes
        - name: LOG_LEVEL
          value: info
        - name: RELEASE_CHANNEL
          value: stable
        - name: LOCAL_ADDRESS
          valueFrom:
            fieldRef:
              fieldPath: status.podIP # is this sufficient?
        - name: PREMKIT_ENABLED
          value: "false"
        ports:
        - containerPort: 9874
        - containerPort: 9880
        - containerPort: 9877
        volumeMounts:
        - name: replicated-persistent
          mountPath: /var/lib/replicated
        - name: replicated-socket
          mountPath: /var/run/replicated
        - name: docker-socket
          mountPath: /host/var/run/docker.sock
        - name: proc
          mountPath: /host/proc
          readOnly: true
      - name: replicated-ui
        image: quay.io/replicated/replicated-ui:stable-2.3.2
        imagePullPolicy: Always
        env:
        - name: LOG_LEVEL
          value: info
        - name: RELEASE_CHANNEL
          value: stable
        ports:
        - containerPort: 8800
        volumeMounts:
        - name: replicated-socket
          mountPath: /var/run/replicated
          readOnly: true
      volumes:
      - name: replicated-persistent
        persistentVolumeClaim:
          claimName: replicated-pv-claim
      - name: replicated-socket
      - name: docker-socket
        hostPath:
          path: /var/run/docker.sock
      - name: proc
        hostPath:
          path: /proc
```

## Create a sample app by using this Kubernetes YAML with Replicated
```yaml
---
  # kind: replicated
  # apiVersion: 2.3.5
  replicated_api_version: "2.3.5"
  version: "alpha"
  name: "Guestbook"
  properties:
    app_url:
      kubernetes:
        value_from:
          services_url:
            name: frontend
            port: 80
    logo_url: http://www.replicated.com/images/logo.png
    console_title: Guestbook Console
  backup:
    enabled: false
  monitors:
    cpuacct: []
    memory: []

  config:
  - name: db
    title: DB
    items:
    - name: redis_slave_replicas
      title: Redis Slave Replicas
      type: text
      default: 2
  - name: frontend
    title: Frontend
    items:
    - name: frontend_replicas
      title: App Replicas
      type: text
      default: 2

  components:
  - name: db-master
    cluster: true
    tags: ["db-master"]
    containers:
    - source: public
      image_name: redis
      version: "3"
      cmd: '[redis-server", "--appendonly", "yes"]'
      ports:
      - private_port: "6379"
        public_port: "6379"
      volumes:
      - host_path: /data/redis
        container_path: /data
      publish_events:
      - name: redis master started
        trigger: container-start
        subscriptions:
        - component: db-slave
          container: redis
          action: start
  - name: db-slave
    cluster: true
    tags: ["db-slave"]
    conflicts: ["db-master"]
    containers:
    - source: public
      image_name: redis
      version: "3"
      cmd: '["redis-server", "--slaveof", "${REDIS_MASTER_SERVICE_HOST}", "6379"]'
      ports:
      - private_port: "6379"
        public_port: "6379"
      env_vars:
      - name: REDIS_MASTER_SERVICE_HOST
        static_val: '{{repl HostPrivateIpAddress "redis-master" "redis" }}'
      publish_events:
      - name: redis slave started
        trigger: container-start
        subscriptions:
        - component: frontend
          container: gb-frontend
          action: start
  - name: frontend
    cluster: true
    tags: ["fe"]
    containers:
    - source: replicated
      image_name: gb-frontend
      version: v4
      ports:
      - private_port: "3000"
        public_port: "80"
      env_vars:
      - name: GET_HOSTS_FROM
        static_val: env
      - name: REDIS_SLAVE_SERVICE_HOST # need lb to cluster
        static_val: '{{repl HostPrivateIpAddress "redis-slave" "redis" }}'
      - name: REDIS_MASTER_SERVICE_HOST
        static_val: '{{repl HostPrivateIpAddress "redis-master" "redis" }}'

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

## Advanced Replicated Configuration
Replicated can be deployed into your kubernetes cluster (TODO: document this) or it can be deployed independently with the following /etc/replicated.conf:
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
