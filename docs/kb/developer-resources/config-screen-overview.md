+++
date = "2016-07-01T00:00:00Z"
lastmod = "2016-07-01T00:00:00Z"
title = "Configuration Screen Overview"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

One of the core features of Replicated is the ability for any application to present users
with a configuration/settings page on which they can input values to be used to customize
their instance. Generally, these settings include things like hostname, SSL certs, SMTP
settings. [Technical documentation config YAML](http://docs.replicated.com/docs/on-prem-config).

![Configuration Screen](/static/config-screen.png)

## Preview with YAML

This screen can be previewed in the vendor portal while viewing the YAML each release. You
can also use the [Replicated Atom Preview Plugin](http://docs.replicated.com/docs/yaml-preview-atom-plugin).

![Config Preview](/static/config-preview.png)

## Reconfigure anytime.

Saved anytime to restart with new values.

![Restart Needed](/static/restart-needed.png)

## Conditional Inputs

Conditional inputs allow you to determine when an item or group is shown.
([technical documentation](http://docs.replicated.com/v1.0/docs/on-prem-config#section-when-conditional-inputs-))

![Conditional Inputs](/static/conditional-inputs.gif)

## Test Commands

Users to validate information like SMTP Auth, SSL Certs, Hostname resolution, GitHub Auth Creds,
and AWS Creds with the use of Replicated [test commands](http://docs.replicated.com/docs/configuration-test-commands).

![Test Procs](/static/test-procs.gif)
