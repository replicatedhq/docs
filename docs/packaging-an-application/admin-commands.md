+++
date = "2016-07-03T04:02:20Z"
title = "Admin Commands"
description = "Implementation guide for application vendors to provide customers with aliased CLI commands that can be performed in the containers across a cluster."
weight = "211"
categories = [ "Packaging" ]

[menu.main]
Name       = "Admin Commands"
identifier = "admin-commands"
parent     = "/packaging-an-application"
url        = "/docs/packaging-an-application/admin-commands"
+++

The `admin_commands` section allows you to define ad-hoc commands that can be executed
inside a running container from the shell.

*Note: If you are calling admin commands from a script use the `--no-tty` flag.*

## Examples

### `nginx-reload`
This example admin command will create a shell alias to allow `mycli nginx-reload` to execute the
command `service nginx reload` inside the running nginx container. This same admin command
will also be available to run with `replicated admin nginx-reload`, or simply as `nginx-reload`

```yaml
properties:
  shell_alias: mycli
admin_commands:
- alias: nginx-reload
  command: [service, nginx, reload]
  run_type: exec
  component: MyComponent
  container: nginx
```

### `redis-sadd`
This example admin command will create a shell alias to allow `mycli redis-sadd mykey myvalue` to execute
the command `redis-cli sadd mykey myvalue` inside the redis container. This same admin command
will also be available to run with `replicated admin redis-sadd mykey myvalue` or `redis-sadd mykey myvalue`

```yaml
properties:
  shell_alias: mycli
admin_commands:
- alias: redis-sadd
  command: [redis-cli, sadd]
  run_type: exec
  component: MyComponent
  container: redis
```

## Configuration
### shell_alias
This is the shell alias that will be created during installation. Commands can be invoked
using this alias or using the replicated CLI directly. Note that this is defined in
Application Properties, not in the admin command.

### alias
This is the command that the user will specify on the command line.  When `shell_alias` is defined, shell aliases will also be created for each individual admin command.

### command
This is the actual command that will be executed inside the container when the alias is
invoked through the replicated CLI.

### run_type
Specify `exec` to execute the command in the currently running container. This is currently
the only option.

### component
Identifies the component under which the container image is defined.

### image
Identifies the image whose container will be used to run the command. This will not create a new
instance of the container; the command will run inside the existing container.
