+++
date = "2016-07-03T04:02:20Z"
title = "YAML Overview"
description = "An overview of the various sections of the Replicated YAML."
weight = "202"
categories = [ "Packaging" ]

[menu.main]
Name       = "YAML Overview"
identifier = "yaml-overview"
parent     = "/packaging-an-application"
url        = "/docs/packaging-an-application/yaml-overview"
+++

Our YAML definition is stored in a public repo at  [https://github.com/replicatedhq/libyaml/](https://github.com/replicatedhq/libyaml/).

## Replicated API Version
At the top of the file we must specify a Replicated API version. For the 2.x replicated we use API version {{<replicated_api_version_current >}}. Note: The [Changelog](https://vendor.replicated.com/#/changelog) tracks the API version.

```yml
replicated_api_version: {{< replicated_api_version_current >}}
```  

## App Basics
The next section includes some basic information about your application release including the app name.

```yml
name: My Enterprise Application
```  

## Detailed App Properties Description
Next we specify some optional application properties. For a list of available properties see [Application Properties](/packaging-an-application/application-properties). You will notice the `{{repl` escape sequence. This invokes a Replicated [template function](/packaging-an-application/template-functions), which will be discussed in more detail soon.

```yml
properties:
  app_url: http://{{repl ThisHostPrivateIpAddress }}
  console_title: My Enterprise Application
```  

## Support Page
We can also specify additional markdown content that will be displayed on the Support page of the admin console:

```yml
console_support_markdown: |
  Documentation for My Enterprise Application can be found [here](http://docs.my-enterprise-application.com).

  When contacting us for help, please download a Support Bundle (below) and attach it to the ticket.  The support
  bundle contains generic system information collected from this server.  It does _not_ contain any data from
  your instance of My Enterprise Application.
```

## Snapshots (Backups)
We can optionally specify a section to enable [Snapshots](/packaging-an-application/snapshots/). The following example will allow your customer to enable snapshots and create a script to run the snapshot.

```yaml
backup:
  enabled: '{{repl ConfigOptionEquals "backup_enabled" "1" }}'
  hidden: '{{repl ConfigOptionEquals "backup_enabled" "0" }}'
  pause_all: false
  script: |
    #!/bin/sh
    myappcli backup
```

If backups are not enabled the Replicated dashboard snapshots tile can be hidden by adding `hidden: true`.

## CMD
The Replicated platform has some built in [commands](/packaging-an-application/commands/) that make writing your configuration much more powerful. In the cmds section you can write commands which we will use later.  These are useful to generate install-time values such as default certs/keys, randomized passwords, JWT token keys, etc.

```yaml
cmds:
- name: postgres_password
  cmd: random
  args:
  - "64"
```

## Components
The [components section](/packaging-an-application/components-and-containers/) is where the containers are defined.  This will include everything from the container image, environment variables, [application orchestration](/packaging-an-application/events-and-orchestration/), config files, [optional clustering](/packaging-an-application/clustering/) and more.

```yaml
components:
- name: Redis
  containers:
  - source: public
    image_name: redis
    version: 3.0.5
```

## Monitors
The containers which make up your components can be monitored for resource usage metrics on an individual basis. For each metric, simply specify each component and container image pair. For example, if you want to see CPU and memory usage metrics for some of your Redis container and your
private worker image pulled from quay.io (in a Worker component):

```yaml
monitors:
  cpuacct:
  - Redis,redis
  - Worker,quay.io/myenterpriseapp/worker
  memory:
  - Redis,redis
  - Worker,quay.io/myenterpriseapp/worker
```

## Custom Metrics
In addition to the default CPU & Memory monitors, Replicated can also display [custom metrics](packaging-an-application/custom-metrics/) sent from the running instance to the on-prem dashboard.

```yml
custom_metrics:
- target: stats.gauges.myapp100.disk.*.*
  retention: "1s:10m,1m:20m,1h:30d"
  aggregation_method: "average"
  xfiles_factor: 0.3
- target: stats.gauges.myapp100.ping.*
  retention: "1s:7d"
  aggregation_method: "last"
  xfiles_factor: 0.6
```  

## Ready State
You can add a health check that Replicated will poll after your containers have all been started. The purpose of this is to report when your application is fully running and ready to start using. Once your application is running, we stop polling this health check and rely on other methods to monitor the status. The timeout parameter allows you to specify (in seconds) how long to keep retrying the command, if it fails. You can use a timeout value of -1 to indicate infinite polling. A timeout of 0 is not supported and causes the default of 10 minutes to be used.

### Available Commands:
- `http_status_code`
- `tcp_port_accept`

```yaml
state:
  ready:
    command: http_status_code
    args:
    - 'http://{{repl HostPublicIpAddress "My Component" "my-web-container" }}/ping'
    - '200'
    timeout: 900
```

## Customer Config Section
This section is where you can configure fields to gather input from the user. This input can be used to further configure your application. The values here can be used as inputs to container environment variables, config files, and more using [template functions](/packaging-an-application/template-functions/) or tested for validity with [test procs](/packaging-an-application/test-procs/). The [config section](/packaging-an-application/config-screen/) is comprised of configuration groups and items. These items will render as a form in the Settings screen of the Replicated admin console.

```yaml
config:
- name: hostname
  title: Hostname
  description: Ensure this domain name is routable on your network.
  items:
  - name: hostname
    title: Hostname
    type: text
    value_cmd:
      name: host_ip
      value_at: 0
    ...
```

## Admin Commands
Optionally you can expose [admin commands](/packaging-an-application/admin-commands/) in your containers. To configure the commands, add the following section. This example will allow the customer to run the `redis-cli` command with any arbitrary arguments. The command will be executed only in the docker containers that match image name and version as well as defined in the named component. A command that will work with this configuration is `replicated admin redis-cli info`. Replicated will find the appropriate node to run this command on; the customer can run these on the main admin console.

```yaml
admin_commands:
- command: redis-cli
  component: DB
  run_type: exec
  image:
    image_name: redis
    version: latest
```

## Custom Preflight Checks
A [preflight check](/packaging-an-application/preflight-checks/) is a test that is run before installing and running an application. The test will analyze the system to determine if the environment meets the minimum requirements and provide feedback during installation if these requirements are not met.

```yaml
host_requirements:
  docker_version: "1.10.3"
  cpu_cores: 2
  cpu_mhz: 2400
  memory: 8GB
  disk_space: 8GB
  replicated_version: ">=2.3.0 <2.4.1"
```

For the full configuration see [Examples](/examples).
