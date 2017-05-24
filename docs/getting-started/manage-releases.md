+++
date = "2016-07-03T04:02:20Z"
title = "Manage Releases"
description = "An introduction to the release channel management workflow for development on the Replicated platform."
weight = "103"
categories = [ "getting-started" ]

[menu.main]
Name       = "Manage Releases"
identifier = "manage-releases"
parent     = "/getting-started"
url        = "/getting-started/manage-releases"
+++

The [Replicated vendor site](https://vendor.replicated.com) provides you with a location to create and release versions of your application to various release channels. By default, there are 3 release channels: Stable, Beta and Unstable. When you first log in to Replicated, you'll see these default release channels created:

![Default Release Channels](/static/empty-release-channels.png)

It's possible to create additional Release Channels using the [Vendor API](/reference/vendor-api/).

## Unstable
The Unstable channel is designed for you to constantly push releases to, much in the same way that you continuously deploy new versions to your cloud product. This is the channel that your development environment should have a license assigned to. You likely will not deliver any Unstable licenses to your customers.

## Beta
The Beta channel is designed to provide a channel to test the upgrade path. You can also choose to license some early-adopting customers against this channel.

## Stable
For most of your customers, you will create a license that assigns them to the Stable channel. By doing so, they'll only receive updates when you push a new version to this channel.
