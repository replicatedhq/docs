+++
date = "2016-07-03T04:12:27Z"
title = "Replicated CLI Reference"
description = "Generated documentation on the default Replicated CLI commands available for all Replicated installed instances."
weight = "505"
categories = [ "Reference" ]

[menu.main]
Name       = "Replicated CLI"
identifier = "replicated-cli"
url        = "/docs/reference/replicated-cli"
parent     = "/reference"
+++

After [installing replicated](http://docs.replicated.com/docs/installing-replicated#section-easy-installation) onto a remote host a CLI is enabled
that can be utilized for both management and maintenance. This tool can be especially helpful when debugging issues that can arise if the
replicated-ui is not fully installed or working properly.

## Source replicated.alias
If command not found is displayed when attempting to execute the replicated CLI we will need to source the replicated.alias file.

```shell
source /etc/replicated.alias
```

## Login
If a console password has been configured this command prompts for the password so that you may still utilize the CLI in an authenticated manner.

```shell
replicated login
```

## Version
List version of currently running replicated components.

```shell
replicated -version
replicated-ui -version
replicated-operator -version
```

## Status
This provides the current status of replicated.

```shell
replicated status
```

## Apps
List ID, Sequence, and Status of running app and prior versions installed on this host.

```shell
replicated apps
```

## Check For Updates
(supported as of 2.0.1608)

This allows you to programmatically trigger a "check for updates" from the CLI.
Note: app-id is retrieved utilizing the apps command.

The -f will ignore any cache on the server already and do a full update check.

```shell
replicated app <app-id> update-check -f
```

## Install An Upgrade
(supported as of 2.0.1608)

This allows you to install an upgrade that is already known to the local installation from the CLI.
Note: app-id is retrieved utilizing the apps command.

```shell
sudo replicated app <app-id> update <sequence>
```

## Generate Support Bundle
(supported as of 1.2.63)

This allows you to generate a support bundle directly from the CLI.
Note: app-id is retrieved utilizing the apps command.

```shell
replicated support-bundle <app-id>
```

## Reset your On-Prem UI password
Your console password can be reset by issuing the following command from the host machine where Replicated
has been installed. (then visit https://<server>/create-password and set a new password)

```shell
replicated auth reset
```

## Hosts
This lists all known hosts that are currently in use by replicated. It includes the following information for
each host : `PRIVATE ADDRESS`, `PUBLIC ADDRESS`, `CONNECTED`, `PROVISIONED`, `AGENT VERSION`, `API VERSION`

```shell
replicated nodes
```

## App
The app command allows you to run the following subcommands on your app from the CLI.
Note: `app-id` is retrieved utilizing the apps command.

- start
- stop (as of version 1.2.63 you can force the app to stop using the optional -f flag)
- update-check (added in version 1.2.88)

```shell
replicated app <app-id> stop -f
```

## Certificate Configuration via CLI
You can set the hostname, key, and cert using the following command.

```shell
replicated console cert set <hostname> /path/to/key /path/to/cert
```

## Tasks
Show the running processes inside replicated.

```shell
replicated tasks
```

## Show Logs of a Task
Using this command you can see the logs associated with a given task.
Note: task-id is retrieved utilizing the apps command.

```shell
replicated task <task-id> logs
```

## Admin
Additionally you can define ad-hoc commands that can be executed inside a running container,
see the dedicated Admin Commands section for more details.
