+++
date = "2016-07-03T04:02:20Z"
title = "Config Screen"
description = "The `config` section of the Replicated YAML creates a dynamic settings page that customers can use to configure their instance."
weight = "204"
categories = [ "Packaging" ]

[menu.main]
Name       = "Config Screen"
identifier = "config-screen"
parent     = "/packaging-an-application"
url        = "/docs/packaging-an-application/config-screen"
+++

The admin console settings screen configuration is specified as an array configuration
groups and items.

## Groups
Groups map to links within the left sidebar navigation. Groups are comprised of a `name`,
`title`, `description` and an array of items.

```yaml
config:
- name: authentication
  title: Authentication
  description: Configure application authentication below.
```

## Items
Items map to input fields and belong to a single group. All items should have `name`, `title`
and `type` properties. Specific item types can including new types.

### Available Item Types
> `label`
> `text`
> `password`
> `file`
> `bool`
> `select_one`
> `select_many`
> `textarea`
> `select`

## Examples

### `select`
Types `select_one` and `select_many` are special cases. These types must have nested items
that act as options. These types will be displayed as radio buttons (`select_one`) or
checkboxes (`select_many`) in the admin console.

```yaml
- name: inputs
  title: Inputs
  description: ""
  items:
  - name: logstash_input_enabled
    title: Choose which Logstash inputs to enable.
    default: ""
    type: select_many
    items:
    - name: logstash_input_file_enabled
      title: File
      default: "0"
    - name: logstash_input_lumberjack_enabled
      title: Lumberjack
      default: "0"
- name: authentication
  title: Authentication
  description: ""
  items:
  - name: authentication_type
    title: Secure your application with authentication.
    default: authentication_type_anonymous
    type: select_one
    items:
    - name: authentication_type_anonymous
      title: Anonymous
    - name: authentication_type_password
      title: Password
```

### `textarea`
A `textarea` can specify a `props` that will map into the HTML element directly.

```yaml
- name: custom_key
  title: Set your secret key for your app
  description: Paste in your Custom Key
  items:
  - name: key
    title: Key
    type: textarea
    props:
      rows: 8
  - name: hostname
    title: Hostname
    type: text
```

### `default` and `value`
A default value will be applied to the ConfigOption template function when no value is
specified. A default value provided via a command (default_cmd) is treated as ephemeral
data that will get overwritten each time commands are executed. It will appear as
placeholder text in the settings section of the On-Prem Console.

A value is data that will be overwritten by user input on non-readonly fields. A value
provided as the result of a command (value_cmd or data_cmd) will persist and will never
change after the first execution of the command. It will appear as the HTML input value
in the settings section of the On-Prem Console.

```yaml
- name: custom_key
  title: Set your secret key for your app
  description: Paste in your Custom Key
  items:
  - name: key
    title: Key
    type: text
    value: ""
    default: localhost
```

## Properties
### `required`
When set, required fields will prevent the application from starting until there is a value.
```yaml
    required: true
```

### `when`
The when value is used to denote conditional inputs that will only be visible (or required) when
the condition evaluates to true.
```yaml
  items:
  - name: key
    type: text
    default: "1"
  - name: value
    type: text
    when: key=1
  - name: key2
    type: text
    default: "1"
  - name: value2
    type: text
    when: key2!=1
```

### `recommended`
An item can be recommended. This item will bear the tag "recommended" in the admin console.
```yaml
    recommended: true
```

### `hidden`
Items can be hidden. They will not be visible if hidden.
```yaml
    hidden: true
```

### `readonly`
Items can be readonly.
```yaml
    readonly: true
```

### `affix`
Items can be affixed left or right. These items will appear in the admin console on the same line.
```yaml
    affix: left
```

## Using CMD (commands) as input to options
Commands can be used as defaults, values, or data with `default_cmd`, `value_cmd` and
`data_cmd` respectively. Data is a special property of the file type. The value corresponds
to the file name while the data corresponds to its contents.

```yaml
    value_cmd:
      name: hash_key
      value_at: 0
```
