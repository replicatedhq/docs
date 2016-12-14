+++
date = "2016-07-01T00:00:00Z"
lastmod = "2016-07-01T00:00:00Z"
title = "Installing Known Versions of Replicated"
weight = "999999"
categories = [ "Knowledgebase", "Supporting Your Customers" ]
+++

Starting with the Replicated 2.0 installation scripts, we support installing specific versions of any of the Replicated components.
Previously, we always installed the most recent version of the Replicated daemons. We would ensure that the “latest” versions
would be compatible with each other and with existing application YAML. But we also recognize that developers depend on Replicated
to provide a known experience each and every installation attempt, so we now do support installing specific versions of our 2.0
release.

The easy installation method of Replicated today is:

```shell
curl -sSL https://get.replicated.com/docker | sudo bash
```

If you want to install a specific version of each of the components, you can simply use:

```shell
curl -sSL "https://get.replicated.com/docker?replicated_tag=2.3.2&replicated_ui_tag=2.3.2&replicated_operator_tag=2.3.2" | sudo bash
```

There are some best practices around using this new functionality:

## 1. Always install versions of the Replicated components that are known to work together.

If you are just starting, we recommend installing using the top (latest) install script and using those versions. Before you
ship to a customer, you can query your test environment to learn which versions are install and pin to these versions. Not all versions
of the Replicated components are compatible with all other versions.

To query the versions of Replicated, you can download a support bundle and look in the versions folder.

Our images are publicly listed at:
https://quay.io/repository/replicated/replicated?tab=tags
https://quay.io/repository/replicated/replicated-ui?tab=tags
https://quay.io/repository/replicated/replicated-operator?tab=tags

You don't need to list the “stable” or “beta” part of the image tag, just the version number. Replicated will automatically install
from the correct channel.

## 2. Proxy this to remove the version numbers from your customer's install script.

For example, if you want to host the installation script on https://get.company.com/docker, we'd recommend setting up an nginx proxy where
you control the versions. Proxy /docker externally to /docker?replicated_tag=x&replicated_ui_tag=y&replicated_operator_tag=z. This gives
you the ability to tell your customers to simply “rerun the installation script” and they will upgrade the Replicated components to a
known version you support.

## 3. Install latest for support sometimes.

Occasionally, when supporting a customer running an older version of Replicated, we may ask that they upgrade it. We ship new versions
constantly, and often will have a fix in a newer version. For this reason, we encourage you to keep as close to “latest” as possible.

We definitely encourage and support any installation that's running a “latest” tag of Replicated. We continue to encourage you to install
from “latest” if possible. But this method will allow you to install known versions for environments when you need a little more control.
