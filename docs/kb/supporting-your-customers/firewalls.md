+++
date = "2016-07-01T00:00:00Z"
lastmod = "2017-03-22T00:00:00Z"
title = "Firewalls"
weight = "999999"
categories = [ "Knowledgebase", "Supporting Your Customers" ]
+++

Often, customers will need to have a complete list of expected internal and outbound network traffic so they can open ports in firewalls and whitelist hosts and IP addresses for outbound connectivity. This document provides the list of all known connections that Replicated requires to run. Any external services required are not listed here.

Note: Airgap installations can run completely offline, and all tasks can be performed with not outbound internet access. Additionally, no installations of Replicated ever require inbound access.

Depending on the current activity, the needs can be different. This document is broken into the task that the customer is attempting to perform, and then broken down by the type of installation they are running.

## Initial Installation of Replicated
When Replicated is installed, it can be downloaded from the Internet or packaged up and delivered in an airgap pacakge. 

| Host | Online Installation | Airgap Installation | Description |
|---|---|---|---|
| get.replicated.com | <i class="fa fa-check" /> Required | <i class="fa fa-times" /> Not Required | This endpoint hosts the install script that used in the Replicated [easy install](/distributing-your-application/installing-via-script) script. |
| quay.io | <i class="fa fa-check" /> Required | <i class="fa fa-times" /> Not Required | The current Replicated images are hosted as public images in the Quay.io registry. |
| Docker Hub | <i class="fa fa-check" /> Required | <i class="fa fa-times" /> Not Required | Some dependencies of Replicated are hosted as public images in Docker Hub.|

## Application Upgrade
To install updates, some external connections are required. All connetions are initiated from inside the network, and can vary depending on the installation method and the application update.

| Host | Online Installation | Airgap Installation | Description |
|---|---|---|---|


## Ongoing Access
When the application is up and running, and not being updated, the requirements for outbound internet access are greatly reduced. It's possible to even run a server completely disconnected from the Internet, and onlty connect when you want to check for updates.

Once the application is installed, your customer can continue to run it, and start and start the application without any outbound access.

In order to perform basic maintence, some outbound access is required, as documented in the table below:

| Task | Host | Online Installation | Airgap Installation | Description |
|---|---|---|---|---|
| Check for updates | api.replicated.com (port 443) | <i class="fa fa-check" /> Required | <i class="fa fa-times" /> Not Required | This endpoint is the only endpoint required to check for application updated. |
| License sync | api.replicated.com (port 443) | <i class="fa fa-check" /> Required | <i class="fa fa-times" /> Not Required | This endpoint is the only endpoint required to sync the license. |






----

<code>This stuff should be merged into the tables above</code>

### Replicated Installation

To install Replicated your customer must allow traffic to the Replicated services and the Quay registry. The replicated installation phase is completed when the install script finishes.

* IP Addresses
  * [Replicated Cloud IPs](https://github.com/replicatedhq/ips/blob/master/ip_addresses.json)
  * Quay Cloud IPs
* Hostnames
  * get.replicated.com
  * Quay Hostnames

### Application Installation or Upgrade

The application installation start with using the Replicated web console and finishes when your images are downloaded. To use the Replicated management console you are required to allow inbound/outbound traffic on TCP port `:8800` to the subnet with which an IT administrator would be accessing the console to configure your application.

For the main Replicated host you must also allow TCP ports `:9870-:9880` to accept both inbound/outbound traffic. Please note that if you are running a multi-host setup communication on these ports will be required between hosts as well as internally.

During your install Replicated will proxy all private images through the Replicated registry. For public images Replicated will pull from the public registry so its hostnames and IPs should be whitelisted.

* IP Addresses
  * [Replicated Cloud IPs](https://github.com/replicatedhq/ips/blob/master/ip_addresses.json)
  * Public image registry IPs
* Hostnames
  * api.replicated.com
  * registry.replicated.com
  * Public image registry hostnames
* Ports
  * Replicated web management console at `8800`
  * Replicated internal traffic on ports `9870-9880`

### Runtime Requirements

Once installed Replicated will perform a license sync on a regular basis but otherwise does not require Internet access. Customers who want to allow upgrades without changing network security policies should include the Application Installation or Upgrade requirements as well.

* IP Addresses
  * [Replicated Cloud IPs](https://github.com/replicatedhq/ips/blob/master/ip_addresses.json)
* Hostnames
  * api.replicated.com
* Ports
  * Replicated internal traffic on ports `9870-9880`
  
Replicated starts Graphite and Statsd containers. Unless otherwise specified in the application YAML, these containers will listen on random, high port numbers to avoid any conflicts. There is a single TCP port for Graphite and a single UDP port for statsd and these ports can be set to any static value in the YAML [custom metrics](https://www.replicated.com/docs/kb/developer-resources/custom-metrics/#graphite) section.
