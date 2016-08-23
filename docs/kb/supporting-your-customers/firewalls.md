+++
date = "2016-07-01T00:00:00Z"
lastmod = "2016-07-01T00:00:00Z"
title = "IPTables and Firewalld"
weight = "999999"
categories = [ "Knowledgebase", "Supporting Your Customers" ]
+++

## Replicated UI

To utilize the Replicated management console you are required to allow inbound/outbound traffic on TCP port `:8800` of the appropriate network interface (`eth0`, `eth1`, etc.) on the host machine where Replicated is installed. This port only needs to be open to the subnet with which an IT administrator would be accessing the console to configure your application.

## Replicated Services Communication

You must also allow TCP ports `:9870-:9880` of the appropriate network interface to accept both inbound/outbound traffic internally on the host machine. Please note that if you are running a multi-host setup communication on these ports will be required between hosts as well as internally.

Replicated also starts a Graphite and Statsd container. Unless otherwise specified in the application YAML, this container will listen on random, high ports to avoid any conflicts with the application itself. There is a single TCP port for Graphite and a single UDP port for statsd. The TCP port used by Graphite can be set to any static value in the YAML as defined in the [custom metrics documentation](https://www.replicated.com/docs/kb/developer-resources/custom-metrics/#graphite).

If you are still having network connectivity issues take a look at this in depth article to help diagnose what might be going on.

Make sure to include these requirements in any 
[customer facing installation instructions](https://support.replicated.com/hc/en-us/articles/216652467) you create.
