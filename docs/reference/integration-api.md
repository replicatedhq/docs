+++
date = "2016-07-03T04:12:27Z"
title = "Replicated Integration API Reference"
description = "Generated documentation on the on-prem features provided by Replicated."
weight = "504"
categories = [ "Reference" ]

[menu.main]
Name       = "Integration API"
identifier = "integration-api"
url        = "/docs/reference/integration-api"
parent     = "/reference"
+++

# Audit API
{{<http_post path="/audit/v1/event">}}

  {{<http_description>}}
  Records audit event information.
  {{</http_description>}}

  {{% http_request_params %}}
| Name | Type | Description |
|------|------|-------------|
| name | String | Name of the event |
| title | String | Title of the event |
| description | String | Hman readable description of the event |
| ip_address | String | IP Address of the user who took the action |
| action | String | Machine readable name of the event |
  {{% /http_request_params %}}

  {{% json_request %}}
```json
{  
    "name":"user.login",
    "description":"john@example.com logged in successfully",
    "title":"User Login Success",
    "action":"user.login.success",
    "ip_address":"192.30.252.12"
}
```
  {{% /json_request %}}

  {{% json_response %}}
```text
HTTP/1.1 201 Created
Date: Tue, 16 Jun 2015 17:59:25 GMT
Content-Length: 0
Content-Type: text/plain; charset=utf-8
```
  {{% /json_response %}}
{{</http_post>}}

# Console API

{{<http_get path="/console/v1/option">}}

  {{<http_description>}}
  Returns values corresponding to the given console option name.
  {{</http_description>}}

  {{% http_request_params %}}
| Name | Type | Description |
|------|------|-------------|
| name | String | Option name |
  {{% /http_request_params %}}

  {{<json_response>}}
Option value (string)
  {{</json_response>}}
{{</http_get>}}

# Identity API

# License API

{{<http_get path="/license/v1/license">}}

  {{<http_description>}}
  Returns current license information.
  {{</http_description>}}

  {{% json_response %}}
```json
{
    "license_id": "f49b290abf39b945c6f519ee6ca1c4ad",
    "installation_id": "44e8188e6fec84ac425829cde0eeee8e",
    "release_channel": "Unstable",
    "fields": [
        {
            "field": "max_hosts",
            "title": "Maximum Number of Hosts",
            "type": "Integer",
            "value": 1,
            "hide_from_customer": false
        },
        {
            "field": "min_hosts",
            "title": "Minimum Number of Hosts",
            "type": "Integer",
            "value": 1,
            "hide_from_customer": false
        },
        {
            "field": "account",
            "title": "Account Name",
            "type": "String",
            "value": "Replicated, Inc",
            "hide_from_customer": false
        }
    ],
    "expiration_time": "2016-01-01T00:00:00Z"
}
```
  {{% /json_response %}}
{{</http_get>}}

{{<http_get path="/license/v1/field/:fieldName">}}

  {{<http_description>}}
  Returns license field.

  {{</http_description>}}

  {{% json_response %}}
```json
{
    "field": "max_queues",
    "value": "99"
}
```
  {{% /json_response %}}
{{</http_get>}}


# Provisioning API

# Status API

# Version API
{{<http_get path="/version/v1/current">}}

  {{<http_description>}}
  Returns information describing the current version of the application running.
  {{</http_description>}}

  {{% json_response %}}
```json
{
  "version": "100",
  "release_sequence": 51,
  "release_notes": "The release notes",
  "release_date":"2015-12-01T00:00:00.0000000Z",
  "install_date":"2016-01-01T21:00:00.0000000Z"
}
```
  {{% /json_response %}}
{{</http_get>}}

{{<http_get path="/version/v1/updates">}}

  {{<http_description>}}
  Returns a list of available updates to install.
  {{</http_description>}}

{{</http_get>}}

{{<http_put path="/version/v1/:sequence">}}

  {{<http_description>}}
  Apply a pending update to the installation. Note that this will install the update immediately and could cause downtime.
  {{</http_description>}}

{{</http_put>}}
