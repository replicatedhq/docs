+++
date = "2016-07-07T04:02:20Z"
title = "LDAP and Identity Integration"
description = "Enabling LDAP and AD user auth and sync in an application through Replicated."
weight = "216"
categories = [ "Packaging" ]

[menu.main]
Name       = "LDAP Integration"
identifier = "ldap"
parent     = "/packaging-an-application"
url        = "/docs/packaging-an-application/ldap-integration"
+++

Replicated can be integrated with LDAP servers to provide real time user authentication & sync. A quick overview of this feature is available Announcement: [DS Auth & Sync Support](https://blog.replicated.com/2015/12/03/ldap-active-directory-sync-support/)

## Configuration
At the root level, configure the identity object

```yaml
identity:
  enabled: '{{repl if ConfigOptionNotEquals "auth_source" "auth_type_internal"}}true{{repl else}}false{{repl end}}'
  provisioner: 'http://{{repl HostPrivateIpAddress "MyContainerName" "Container Image Name"}}:6006'
  sources:
  - source: ldap
    enabled: '{{repl if ConfigOptionEquals "auth_source" "auth_type_ldap"}}true{{repl else}}false{{repl end}}'
```

| Field |	Description |
|-------|-------------|
| enabled | This should be copied as shown in the example. The value will depend on the settings provided below. |
| provisioner | (Optional) Host that provides provisioning API for synchronization with LDAP. This field can be omitted if synchronization is not needed. |
| sources | Only `ldap` source is supported at this time. Leave this setting as shown in the example. |

In the config section, add LDAP server configuration

{{< note title="Setting names" >}}
Setting labels can be customized if needed. However, setting names must remain exactly as shown in this example.
{{< /note>}}

```yaml
- name: auth
  title: Authentication
  description: Where will user accounts be provisioned
  items:
  - name: auth_source
    default: auth_type_internal
    type: select_one
    items:
    - name: auth_type_internal
      title: Built In
    - name: auth_type_ldap
      title: LDAP
- name: ldap_settings
  title: LDAP Server Settings
  when: auth_source=auth_type_ldap
  items:
  - name: ldap_type
    title: LDAP Server Type
    type: select_one
    default: ldap_type_openldap
    items:
    - name: ldap_type_openldap
      title: OpenLDAP
    - name: ldap_type_ad
      title: Active Directory
    - name: ldap_type_other
      title: Other
  - name: ldap_hostname
    title: Hostname
    type: text
    value: '{{repl LdapCopyAuthFrom "Hostname"}}'
    required: true
  - name: ldap_port
    title: Port
    type: text
    value: '{{repl LdapCopyAuthFrom "Port"}}'
    default: 389
    required: true
  - name: label_encryption_label
    title: Encryption Type
    type: label
  - name: ldap_encryption
    type: select_one
    default: ldap_encryption_plain
    items:
    - name: ldap_encryption_plain
      title: Plain
  - name: ldap_search_user
    title: Search user
    type: text
    value: '{{repl LdapCopyAuthFrom "SearchUsername"}}'
    required: true
  - name: ldap_search_password
    title: Search password
    type: password
    value: '{{repl LdapCopyAuthFrom "SearchPassword"}}'
    required: true
  - name: ldap_schema
    type: heading
    title: LDAP schema
  - name: ldap_base_dn
    title: Base DN
    type: text
    value: '{{repl LdapCopyAuthFrom "BaseDN"}}'
    required: true
  - name: ldap_usersearch_dn
    title: User search DN
    type: text
    value: '{{repl LdapCopyAuthFrom "UserSearchDN"}}'
    default: ou=users
    required: true
  - name: ldap_restricted_user_group
    title: Restricted User Group
    type: text
    value: '{{repl LdapCopyAuthFrom "RestrictedGroupCNs"}}'
    required: false
  - name: ldap_username_field
    title: Username field
    type: text
    value: '{{repl LdapCopyAuthFrom "FieldUsername"}}'
    default: uid
    required: true
```

Note the use of the LdapCopyAuthFrom function. This is optional, but when LDAP is used to secure the Replicated console, settings entered on that screen will be copied as default values.

## Identity API
See [Identity API](/reference/integration-api) for information on how to authenticate and sync with LDAP server.
