+++
date = "2016-07-03T04:02:20Z"
title = "Create & Manage Releases"
description = "An introduction to the release channel management workflow for development on the Replicated platform."
weight = "103"
categories = [ "Getting Started" ]

[menu.main]
Name       = "Create & Manage Releases"
identifier = "manage-releases"
parent     = "/getting-started"
url        = "/docs/getting-started/manage-releases"
+++
## Create Releases
The [Replicated vendor portal](https://vendor.replicated.com) provides you with a location to create and release versions of your application to various release channels.

## Manage Releases & Channel
By default, there are 3 release channels: Stable, Beta and Unstable. When you first log in to Replicated and select the Channels tab, you'll see these default release channels created:

### Stable
For most of your customers, you will create a license that assigns them to the Stable channel. By doing so, they'll only receive updates when you push a new version to this channel.

### Beta
The Beta channel is designed to provide a channel to test the upgrade path. You can also choose to license some early-adopting customers against this channel.

### Unstable
The Unstable channel is designed for you to constantly push releases to, much in the same way that you continuously deploy new versions to your cloud product. This is the channel that your development environment should have a license assigned to. You likely will not deliver any Unstable licenses to your customers.

In addition to creating additional Release Channels in the [Replicated vendor site](https://vendor.replicated.com/channels), you can also use the [Vendor API](/reference/vendor-api/).
