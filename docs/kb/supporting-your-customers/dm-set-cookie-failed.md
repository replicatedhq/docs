+++
date = "2016-08-22T00:00:00Z"
lastmod = "2016-08-22T00:00:00Z"
title = "Can not set cookie: dm_set_cookie failed"
weight = "999999"
categories = [ "Knowledgebase", "Supporting Your Customers" ]
+++

When dealing with a large number of containers pulling in parallel, containers may fail with the following error:

```
Failed to remove replicated container, retrying
Error response from daemon: driver "devicemapper" failed to remove root filesystem for 3d101377c1f7124c941329953db8287c052679b7ec77bd65bb14cc8018e0d212: failed to remove device 285b6331bf7fc15d068a93e30f3cc0a9cb0c42d1755fbdd64b1f26f015e5f530: devicemapper: Can not set cookie: dm_task_set_cookie failed
```

This has been identified as a regression in devicemapper and will be fixed in future versions of Docker. In the meantime, there are two ways to fix this issue.

# Restart the Docker Daemon

Restarting the Docker daemon periodically will free up leaked semaphores, allowing containers to be properly created.

# Increase Semaphore Limits

For a more permenant solution, increase the number of semaphores in sysctl settings. There is no specific maximum to the number of semaphores and semaphore sets that should be pre-allocated on systems, but is dependent on CPU and available RAM. To see the current settings, run:

```
$ cat /proc/sys/kernel/sem
250     32000   32     128
```

In order, these parameters are:

* SEMMSL - Maximum number of semaphores per semaphore set
* SEMMNS - Maximum number of Linux-wide semaphores
* SEMOPM - Maximum semaphore operations per semaphore system call
* SEMMNI - Maximum number of semaphore sets

To double the number of semaphore sets and semaphores in the sysctl settings, run the followin gcommand:

```
sysctl -w kernel.sem="500 128000 100 256"
```

Note that SEMMNS = SEMMSL * SEMMNI. This ensures that the number of semaphore sets and semaphores per sets can be fully utilized. This can also be changed without restart with:

```
echo 500 128000 100 256 > /proc/sys/kernel/sem
```

After setting these values, restart Docker or your system to apply the changes.