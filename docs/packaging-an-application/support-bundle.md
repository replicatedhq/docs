+++
date = "2016-07-03T04:02:20Z"
title = "Support Bundle"
description = "Installed instances can generate a support bundle with relevant logs and instance information."
weight = "212"
categories = [ "Packaging" ]

[menu.main]
Name       = "Support Bundle"
identifier = "support-bundle"
parent     = "/packaging-an-application"
url        = "/docs/packaging-an-application/support-bundle"
+++

A support bundle archive will be available for your customer to download via the Support tab of the On-Prem Console.

You can customize the content on the page by including markdown in top-level​ your YAML.

Support bundle collection of any specific item, command or file will timeout after 30 seconds. The entire package will download all successful files, commands etc collected in less then the 30 second mark.

```yaml
replicated_api_version: "{{< replicated_api_version_current >}}"
name: ELK
console_support_markdown: |
  # Email Us for help:
  #### support@getelk.com
  Or don't, your loss.
```

## Default Support Files
You can identify [custom support bundle files](/packaging-an-application/components-and-containers/#custom-support-bundle-files) in your app configuration yaml, but by default the support bundle will include the following files:

| File | Description |
|------|-------------|
| /daemon/nodes.txt | A list of all nodes and their status. |
| /daemon/config-commands.txt | A list of all configuration test commands that were run and the results. |
| /daemon/tasks.txt | A list of all current tasks: queued, executing, or sleeping |
| /daemon/ledis-app.dump | A dump of the Replicated Ledis database. |
| /daemon/ledis-registry.dump | A dump of the Replicated registry Ledis database. |
| /daemon/replicated.log | Logs from the Replicated container. |
| /daemon/replicated-ui.log | Logs from the Replicated UI container |
| /daemon/replicated-inspect.json | Docker inspect from the Replicated container. |
| /daemon/replicated-ui-inspect.json | Docker inspect from the Replicated-ui container. |
| /nodes/*&lt;node_alias&gt;*/scheduler/replicated-operator.log | Logs from the Replicated Operator container. |
| /nodes/*&lt;node_alias&gt;*/scheduler/replicated-operator-inspect.json | Docker inspect from the Replicated Operator container. |
| /nodes/*&lt;node_alias&gt;*/scheduler/replicated/host/etc/replicated-operator.conf | Contents of the Replicated Operator container conf. |
| /nodes/*&lt;node_alias&gt;*/etc/os-release | A copy of the `/etc/os-release` file. Contains operating system identification data. |
| /nodes/*&lt;node_alias&gt;*/proc/meminfo | A copy of the `/proc/meminfo` file. Reports valuable information about the systems RAM usage. |
| /nodes/*&lt;node_alias&gt;*/proc/cpuinfo | A copy of the `/proc/cpuinfo` file. Reports valuable information about the systems CPU usage. |
| /nodes/*&lt;node_alias&gt;*/proc/mounts | A copy of the `/proc/mounts` file. Provides a list of all mounts in use by the system. |
| /nodes/*&lt;node_alias&gt;*/proc/vmstat | A copy of the `/proc/vmstat` file. Shows detailed virtual memory statistics from the kernel. |
| /nodes/*&lt;node_alias&gt;*/commands/hostname | Result of `hostname` command. Shows the host name of the server. |
| /nodes/*&lt;node_alias&gt;*/commands/date | Result of `date` command. Displays the date on the server. |
| /nodes/*&lt;node_alias&gt;*/commands/ps | Result of `ps fauxwww` command. Displays processes running on the system. |
| /nodes/*&lt;node_alias&gt;*/commands/lsmod | Result of `lsmod` command. Displays which loadable kernel modules are currently loaded. |
| /nodes/*&lt;node_alias&gt;*/commands/lspci | Result of `lspci` command. Displays information about PCI buses in the system and devices connected to them. |
| /nodes/*&lt;node_alias&gt;*/commands/lsof | Result of `lsof -b -M -n -l` command. Lists information about the files that are opened by various processes. |
| /nodes/*&lt;node_alias&gt;*/commands/blkid | Result of `blkid` command. Displays information about available block devices. |
| /nodes/*&lt;node_alias&gt;*/commands/btrfs | Result of `btrfs fi show` command. Shows the btrfs filesystem with some additional info. |
| /nodes/*&lt;node_alias&gt;*/commands/df_ali | Result of `df -ali` command. Report file system disk space usage. |
| /nodes/*&lt;node_alias&gt;*/commands/df_ai | Result of `df -al` command. Report file system disk space usage. |
| /nodes/*&lt;node_alias&gt;*/commands/ip_addr_show | Result of `ip -o addr show` command. Shows protocol (IP or IPv6) addresses. |
| /nodes/*&lt;node_alias&gt;*/commands/ip_link_show | Result of `ip -o link show` command. Shows network devices. |
| /nodes/*&lt;node_alias&gt;*/commands/ip_route_show | Result of `ip -o route show` command. Shows routing table entries. |
| /nodes/*&lt;node_alias&gt;*/commands/netstat_-neopa | Result of `netstat -neopa` command. Displays network connections, routing tables, interface statistics, masquerade connections, and multicast memberships. |
| /nodes/*&lt;node_alias&gt;*/commands/free | Result of `free -m` command. Displays amount of free and used memory in the system. |
| /nodes/*&lt;node_alias&gt;*/commands/docker_ps | Result of `docker ps -a` command. Lists all Docker container. |
| /nodes/*&lt;node_alias&gt;*/commands/dmesg | Result of `dmesg` command. |
| /nodes/*&lt;node_alias&gt;*/commands/uname | Result of `uname` command. |
| /nodes/*&lt;node_alias&gt;*/commands/uptime | Result of `uptime` command. |
| /nodes/*&lt;node_alias&gt;*/docker/docker_info.json |
| /nodes/*&lt;node_alias&gt;*/docker/docker_ps_a.json |
| /nodes/*&lt;node_alias&gt;*/replicated/host/var/log/upstart/docker.log |
| /container/*&lt;container_alias&gt;*/inspect | Result of `docker inspect <container_id>` command. Displays low-level information on a Docker container. |
| /container/*&lt;container_alias&gt;*/stdout.log | Result of `docker logs <container_id>` command. Fetches the stdout logs of a Docker container. |
| /container/*&lt;container_alias&gt;*/stderr.log | Result of `docker logs <container_id>` command. Fetches the stderr logs of a Docker container. |
| /container/*&lt;container_alias&gt;*/files | Contains any custom container files as specified by the vendor. |
| /container/*&lt;container_alias&gt;*/commands | Contains any custom container commands as specified by the vendor. |
| /daemon/commands/dmesg | Result of `dmesg` command. |
| /daemon/commands/docker | Version of Docker. |
| /daemon/commands/replicated-ui | Version of ReplicatedUI. |
| /daemon/commands/replicated-updater | Version of ReplicatedUpdater. |
| /daemon/commands/uptime | Result of `uptime` command. |
| /daemon/proc/cpuinfo | result of `/proc/cpuinfo` |
| /daemon/var/log/upstart/* | Replicated upstart logs (UI, Updater, Replicated) |
| /daemon/commands/uname | result of `uname -a (-r)` |
| /daemon/auditlogs-* | audit log events |
| /hosts/<host_alias>*/var/log/docker.log | docker log from the host |
