+++
date = "2016-07-03T04:02:20Z"
title = "Upgrading Replicated"
description = "The process for end customers to update Replicated services to access the latest improvements to the underlying system since their installation."
weight = "307"
categories = [ "Distributing" ]

[menu.main]
Name       = "Upgrading Replicated"
identifier = "upgrading-replicated"
parent     = "/distributing-an-application"
url        = "/docs/distributing-an-application/upgrading"
+++

{{< note title="Replicated 2.0" >}}
The content in this document is specific to Replicated 2.0. If you are looking for the
Replicated 1.2 version of this document, it is available at
<a href="distributing-an-application/upgrading-1.2/">{{< baseurl >}}distributing-an-application/upgrading-1.2/</a>
{{< /note >}}

You can update all Replicated component versions to latest by re-running the installation
script.

```shell
curl -sSL https://get.replicated.com/docker | sudo bash
```

If you have additional nodes you will independently need to run the following on each of them.

```shell
curl -sSL https://get.replicated.com/operator | sudo bash
```
