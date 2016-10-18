+++
date = "2016-07-03T04:02:20Z"
title = "Create Licenses"
description = "Details on the options available to vendors when creating a license for an end customer's upcoming installation."
weight = "302"
categories = [ "Distributing" ]

[menu.main]
Name       = "Create Licenses"
identifier = "create-licenses"
parent     = "/distributing-an-application"
url        = "/docs/distributing-an-application/create-licenses"
+++

Each customer you deploy to via Replicated will need a separate license file for their
installation. This license file identifies the customer & application at time of
installation and update. Licenses & custom license fields are created & managed in the
[vendor portal](https://vendor.replicated.com/#/licenses) or via the
[Vendor License API](/reference/vendor-api).

## General Info

### Customer Name
The human readable name of the customer.

### License Channel (Required)
When you create a license you'll need to assign it to a release channel (if it is a customer,
likely channel is Stable, but for your internal testing you'll also likely need unstable &
 beta licenses). (More about release channel management).

### Expiration (Required)
When you create a license you can specify how the license will behave when it expires.  The policy
can ignore expiration, allow a running application to continue but prevent updates, or stop
the running application and prevent updates.  License expiration to stop running the application is supported in Replicated 2.1.0
or newer.

## Policies

### Update Policy
Replicated has two available update policies: `Manual` and `Automatic`. Manual updates will require that your customer visit the admin console to read the release notes and apply the update (this is the default setting). Automatic updates will be automatically applied whenever Replicated detects a new version is available (this could cause downtime as Replicated will stop the containers before starting the new ones).

### Clustered Installations Enabled
If your application supports clustered installations, you can toggle the ability for a clustered installation from the license level by enabling/disabling this feature. If enabled, your customer will see the "add node" button on the "cluster" screen of the admin console. If disabled, this button will not be visible (this is the default setting).

### Enable Console LDAP Authentication
During the installation process, immediately after your customer uploads their `.rli` license file, they're promoted to "Secure the admin console". By default there are 3 options "unsecured", "password" or "LDAP". By toggling this license setting to off you can remove the option to leverage LDAP for the admin console.

### License Activation (Optional)
The license file becomes the key to download & install your application. For this reason,
it is wise to enable the [license activation feature](/kb/supporting-your-customers/two-factor-licenses)
on all licenses. This will add a simple step to your customer's installation experience,
where the email you specify will be sent an activation code required to proceed pass step 2
in the process.

## Billing Info (Optional)
You can identify a license as `Development`, `Trial` or `Paid`. Development licenses are intended for internal usage for ongoing development. Trial licenses should have an expiration assigned (generally 4-8 weeks). Paid licenses will prompt for billing information to be entered on the subsequent screen. This billing information allows you to communicate license revenue to Replicated for billing (note: an invoice will not be sent to your customer).

## Custom License Fields (Optional)
Custom license fields can be set for all licenses. This is useful if specific customer
information might change from customer to customer. These fields can be read from both
the [template functions](/packaging-an-application/template-functions)) as well as from
the [Integetration API](/reference/integration-api). Examples of custom license fields are
"seats" to limit the number of active users or "hostname" in order to specify the domain
that the application can be run on.
