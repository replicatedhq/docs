+++
date = "2016-07-26T00:00:00Z"
lastmod = "2016-07-26T00:00:00Z"
title = "Kubernetes Pre-release"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

A future release of Replicated will support deploying Replicated and your application to a Kubernetes cluster. This is currently available as a pre-release feature, and is not ready to deliver to any production installations.

{{< note title="Pre-Release Version" >}}
The features and the implementation described in this document is subject to change before final release. Any YAML created using this information may not be compatible with the final release.
{{< /note >}}

## Requirements
You should have a standard Kubernetes YAML available to deploy. This configuration can contain any number of pods, services and replication controllers. Replicated expects that the YAML will contain exactly one delpoyment spec. Monitoring this deployment is how Replicated will start and stop and update the application in Kubernetes. 

## Known Limitations
- Template functions are not supported
- Admin commands are not supported
- Snapshots are not supported
- Support Bundle is not supported
- Saving settings works but shows an error

## Create a Replicated YAML with Kubernetes 
```yaml
---
replicated_api_version: "2.3.5"
name: "My Application"
properties:
  app_url: http://{{repl NodePublicIpAddress "Python Web" "marc/reference"}}
  logo_url: http://www.replicated.com/images/logo.png
  console_title: My Application

config:
  - name: Basic Information
    title: Basic Information
    description: Some basic information about this server
    items:
      - name: hostname
        title: Hostname or IP Address of this server
        type: text
        value_cmd:
          name: host_ip
          value_at: 0

kubernetes:
  config: |
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
      replicas: 3
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

(Note: The Kubernetes definition is supplied as a string. It's not currently validated by the Replicated system).

## Configure Replicated
Before installing Replicated, create the file /etc/replicated.conf, for example:
```json
{
        "BypassPreflightChecks": true,
        "SchedulerEngine": "kubernetes",
        "K8sHost": "https://10.10.10.10",
        "K8sUsename": "admin",
        "K8sPassword": "password",
        "K8sClusterCACertData": "<base64 encoded cert>"
}
```

## Install replicated
`curl -sSL https://get.replicated.com/docker | sudo bash`
