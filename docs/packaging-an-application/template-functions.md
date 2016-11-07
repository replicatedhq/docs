+++
date = "2016-07-03T04:02:20Z"
title = "Template Functions"
description = "The dynamic configuration management functionality available throughout the Replicated YAML."
weight = "210"
categories = [ "Packaging" ]

[menu.main]
Name       = "Template Functions"
identifier = "template-functions"
parent     = "/packaging-an-application"
url        = "/docs/packaging-an-application/template-functions"
+++

Template functions are marked by the double curly bracket + *"repl"* escape sequence. They allow for user input to be
dynamically inserted into application configuration values. The sequence should be `{{repl`, not `{{ repl`.

### Go Templates
Replicated uses Go's [template engine](http://golang.org/pkg/text/template) to execute the following functions.  In addition
to the functions listed here, all of the Go template runtime is available.  Please note that Go template functions must still
be escaped with "repl" escape sequence as demonstrated below.

```go
{{repl if pipeline}} T1 {{repl else}} T0 {{repl end}}
```

# Replicated Template Functions

## ConfigOption
```go
func ConfigOption(optionName string) string
```
Returns the value of the config option as a string.
```yml
properties:
  app_url: http://{{repl ConfigOption "hostname" }}
```

## ConfigOptionData
(only supports `type: file`)

```go
func ConfigOptionData(fileName string) string
```
Returns the contents of the file uploaded for a configuration option as a string.
```yml
config_files:
- filename: /opt/certs/server.key
  contents: {{repl ConfigOptionData "ssl_key"}}
```

## ConfigOptionEquals
```go
func ConfigOptionEquals(optionName string, expectedValue string) bool
```
Returns true if the configuration option value is equal to the supplied value.
```yml
ports:
   - private_port: "80"
     public_port: "80"
     port_type: tcp
     when: '{{repl ConfigOptionEquals "http_enabled" "1" }}'
```

## ConfigOptionNotEquals
```go
func ConfigOptionNotEquals(optionName string, expectedValue string) bool
```
Returns true if the configuration option value is not equal to the supplied value.
```yml
ports:
   - private_port: "443"
     public_port: "443"
     port_type: tcp
     when: '{{repl ConfigOptionNotEquals "http_enabled" "1" }}'
```

## HostPrivateIpAddress
```go
func HostPrivateIpAddress(componentName string, containerName string) string
```
Returns Private IP Address of Component as a string.
```yml
env_vars:
- name: REDIS_HOST_PRIVATE
  static_val: '{{repl HostPrivateIpAddress "DB" "redis" }}'
```

## HostPrivateIpAddressAll
```go
func HostPrivateIpAddressAll(componentName string, containerName string) []string
```
Returns host private IP addresses for all instances of a given Component as an array of strings.
Note: `ContainerExposedPortAll`, `HostPrivateIpAddressAll`, `HostPublicIpAddressAll` are guaranteed to return in the same order

## HostPublicIpAddress
```go
func HostPublicIpAddress(componentName string, containerName string) string
```
Returns Public IP Address of Component as a string.
```yml
env_vars:
- name: REDIS_HOST_PUBLIC
  static_val: '{{repl HostPublicIpAddress "DB" "redis" }}'
```

## HostPublicIpAddressAll
```go
func HostPublicIpAddressAll(componentName string, containerName string) []string
```
Returns host public IP addresses for all instances of a given Component as an array of strings.
Note: `ContainerExposedPortAll`, `HostPrivateIpAddressAll`, `HostPublicIpAddressAll` are guaranteed to return in the same order

## ContainerExposedPort
```go
func ContainerExposedPort(componentName string, containerName string, internalPort string) string
```
Returns the host's public port mapped to the supplied exposed container port as a string. The containerName argument references the image_name property from the container yaml. When using this function the referencing container must start *after* the container specified in the argument. See the [Events and Orchestration](https://www.replicated.com/docs/packaging-an-application/events-and-orchestration/) section for more information on orchestrating container startup.

```yml
env_vars:
- name: REDIS_PORT
  static_val: '{{repl ContainerExposedPort "DB" "redis" "6379" }}'
```

## ContainerExposedPortAll
```go
func ContainerExposedPortAll(componentName string, containerName string, internalPort string) string
```
Returns the host public port mapped to the supplied exposed container port for all instances of a given Component as an array of strings.
Note: `ContainerExposedPortAll`, `HostPrivateIpAddressAll`, `HostPublicIpAddressAll` are guaranteed to return in the same order

## LicenseFieldValue
```go
func LicenseFieldValue(customLicenseFieldName string) string
```
Returns the value for the Custom License Field as a string.
```yml
config_files:
  - filename: /opt/app/config.yml
    contents: |
      max_users: '{{repl LicenseFieldValue "maximum_users" }}'
```

## LicenseProperty
```go
func LicenseProperty(propertyName string) string
```
Returns a property from the License as a string.  Valid propertyNames are "assignee", "channel.name", "expiration.date", and "expiration.policy".
```yml
config_files:
  - filename: /opt/app/config.yml
    contents: |
      expiration.date: {{repl LicenseProperty "expiration.date"}}
```


## AppSetting
```go
func AppSetting(key string) string
```
Returns a setting from the current app release.

Possible Options:
`version.label`
`release.notes`
`release.date`
`install.date`
`release.channel`

```yml
env_vars:
- name: VERSION
  static_val: '{{repl AppSetting "version.label"}}'
- name: RELEASE_NOTES
  static_val: '{{repl AppSetting "release.notes"}}'
- name: INSTALL_DATE
  static_val: '{{repl AppSetting "install.date"}}'
- name: RELEASE_DATE
  static_val: '{{repl AppSetting "release.date"}}'
- name: RELEASE_CHANNEL
  static_val: '{{repl AppSetting "release.channel"}}'
```

## ConsoleSetting
```go
func ConsoleSetting(consoleSettingName string) string
```
Returns customer defined console settings for the TLS data provided by customers during their initial setup as a string.

Possible Options:
`tls.key.name`
`tls.cert.name`
`tls.key.data`
`tls.cert.data`
`tls.hostname`
`tls.source` (where the tls cert/key originated from)

```yml
config:
- name: console_info
  title: Console Info
  items:
  - name: key_filename
    type: text
    readonly: true
    value: '{{repl ConsoleSetting "tls.key.name"}}'
```

## ThisHostInterfaceAddress
Deprecated, please use ThisNodePublicIPAddress, ThisNodePrivateIPAddress or ThisNodeDockerAddress instead.
```go
func ThisHostInterfaceAddress(interfaceName string) string
```
Returns the first valid IPv4 address associated with the given network interface of the host on which the current container instance is deployed as a string.
For a clustered application this value will be different for each host.
```yml
env_vars:
- name: CASSANDRA_BROADCAST_ADDRESS_INTERNAL
  static_val: '{{repl ThisHostInterfaceAddress "docker0" }}'
```

## ThisNodePublicIPAddress
```go
func ThisNodePublicIPAddress() string
```
Returns the public IP address of the host on which the current container instance is deployed as a string.
For a clustered application this value will be different for each host.
```yml
env_vars:
- name: CASSANDRA_ADDRESS_PUBLIC
  static_val: "{{repl ThisNodePublicIPAddress }}"
```
Replaces ThisHostPublicIpAddress which is deprecated.

## ThisNodePrivateIPAddress
Deprecated, please use ThisNodePrivateIPAddress.
```go
func ThisNodePrivateIPAddress() string
```
Returns the private IP address of the host on which the current container instance is deployed as a string. This address is either what was entered manually when host was provisioned or detected from eth0 interface by default.
For a clustered application this value will be different for each host.
```yml
env_vars:
- name: CASSANDRA_BROADCAST_ADDRESS_INTERNAL
  static_val: "{{repl ThisNodePrivateIPAddress }}"
```
Replaces ThisHostPrivateIpAddress which is depreciated.

## ThisNodeDockerAddress
```go
func ThisNodeDockerAddress() string
```
Returns the docker0 address on the host on which the current container instance is deployed.
For a clustered application this value will be different for each host.


## Now
```go
func Now() string
```
Returns the current timestamp as an RFC3339 formatted string.
```yml
env_vars:
- name: START_TIME
  static_val: "{{repl Now }}"
```

## Split
```go
func Split(s string, sep string) []string
```
Split slices s into all substrings separated by sep and returns an array of the substrings between those separators.
```yml
env_vars:
  - name: BROKEN_APART_A_B_C
    static_val: '{{repl Split "A,B,C" "," }}'
```

## LdapCopyAuthFrom
```go
func LdapCopyAuthFrom(keyName string) string
```
Possible Options:
`Hostname`
`Port`
`SearchUsername`
`SearchPassword`
`BaseDN`
`UserSearchDN`
`RestrictedGroupCNs`
`FieldUsername`
`LoginUsername`
```yml
env_vars:
  - name: LDAP_HOSTNAME
    static_val: '{{repl LdapCopyAuthFrom "Hostname"}}'
```

## ToLower
```go
func ToLower(stringToAlter string) string
```
Returns the string, in lowercase.
```yml
env_vars:
- name: COMPANY_NAME
  static_val: '{{repl ConfigOption "company_name" | ToLower }}'
```

## ToUpper
```go
func ToUpper(stringToAlter string) string
```
Returns the string, in uppercase.
```yml
env_vars:
- name: COMPANY_NAME
  static_val: '{{repl ConfigOption "company_name" | ToUpper }}'
```

## UrlEncode
```go
func UrlEncode(stringToEncode string) string
```
Returns the string, url encoded.
```yml
env_vars:
- name: SMTP_CONNECTION_URL
  static_val: '{{repl ConfigOption "smtp_email" | UrlEncode }}:{{repl ConfigOption "smtp_password" | UrlEncode }}@smtp.example.com:587'
```

## Base64 Encode
```go
func Base64Encode(stringToEncode string) string
```
Returns a Base64 encoded string.
```yml
env_vars:
- name: NAME_64_VALUE
  static_val: '{{repl ConfigOption "name" | Base64Encode }}'
```

## Base64 Decode
```go
func Base64Decode(stringToDecode string) string
```
Returns decoded string from a Base64 stored value.
```yml
env_vars:
- name: NAME_PLAIN_TEXT
  static_val: '{{repl ConfigOption "base_64_encoded_name" | Base64Decode }}'
```

## Add
```go
func Add(x interface{}, y interface{}) interface{}
```
Adds x and y.

If at least one of the operands is a floating point number, the result will be a floating point number.

If both operands are integers, the result will be an integer.
```yml
env_vars:
- name: MAX_USERS_PLUS_ONE
  static_val: '{{repl Add (LicenseFieldValue "maximum_users") 1}}'
```

## Sub
```go
func Sub(x interface{}, y interface{}) interface{}
```
Subtracts y from x.

If at least one of the operands is a floating point number, the result will be a floating point number.

If both operands are integers, the result will be an integer.
```yml
env_vars:
- name: MAX_USERS_MINUS_ONE
  static_val: '{{repl Sub (LicenseFieldValue "maximum_users") 1}}'
```

## Mult
```go
func Mult(x interface{}, y interface{}) interface{}
```
Multiplies x and y.

If at least one of the operands is a floating point number, the result will be a floating point number.

If both operands are integers, the result will be an integer.
```yml
env_vars:
- name: DOUBLE_NUM_ADDRESSES
  static_val: '{{repl Mult (NodePrivateIPAddressAll "DB" "redis" | len) 2}}'
```

## Div
```go
func Div(x interface{}, y interface{}) interface{}
```
Divides x by y.

If at least one of the operands is a floating point number, the result will be a floating point number.

If both operands are integers, the result will be an integer and will be rounded down.
```yml
env_vars:
- name: HALF_MAX_USERS
  static_val: '{{repl Div (LicenseFieldValue "maximum_users") 2.0}}'
```
