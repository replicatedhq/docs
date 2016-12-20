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

Each customer you deploy to via Replicated will need a separate license file for their installation. This license file identifies the customer & application during the installation and update processes. Licenses & custom license fields are created & managed in the [vendor portal](https://vendor.replicated.com/#/licenses) or via the [Vendor License API](/reference/vendor-api/license/). License values are used by Replicated to enable/disable various functionality, many of the values are also available in the on-prem instance via the [license integration API](https://replicated.readme.io/docs/license-api).

## Customer (Required)
The name of the customer to whom this license is assigned.

## License Channel (Required)
When you create a license you'll need to assign it to a release channel (if it is a customer,
likely channel is Stable, but for your internal testing you'll also likely need unstable &
 beta licenses). [More about release channel management](/docs/getting-started/manage-releases/)).

## Expiration
When you create a license you can specify how the license will behave when it expires.  The policy can ignore expiration, allow a running application to continue but prevent updates, or stop the running application and prevent updates.  License expiration to stop running the application is supported in Replicated 2.1.0 or newer.

## Update Policy
By default, licenses will be set to manual updates. This means that the end customer will need to read the release notes and [click a button to apply the update](https://blog.replicated.com/2015/12/31/1-click-update-experience/). It is possible to turn on automatic updates, which will apply any update when it is detected.

## Clustered Installations Enabled
By default, licenses will be set to disable clustered installations. This will prevent the "[add node](http://localhost:5913/docs/distributing-an-application/add-nodes/)" button from appearing on the Cluster tab of the on-prem admin console.

## Enable Console LDAP Authentication
By default, licenses will be set to enable the admin to setup LDAP/AD as the method of authenticating into the on-prem admin console. By turning this feature off, the end customer will only see the options to keep authentication anonymous or to create a shared password for the admin console.

## Require Activation
The license file becomes the key to download & install your application. For this reason, it is wise to enable the [license activation feature](/kb/supporting-your-customers/two-factor-licenses) on all licenses. This will add a simple step to your customer's installation experience, where the email you specify will be sent an activation code required to proceed past step 2 in the process.

## Airgap Download Enabled
By default, licenses will be set to disable [airgap installations](https://blog.replicated.com/2016/05/24/airgapped-installation-support/). By enabling this feature, the actual `.rli` file will have license meta data embedded in it and must be redownloaded.

## License Type (Required)
It is important to identify the type of license that is being created, `development`, `trial` or `paid`. Development licenses are designed to be used internally by the development team for testing and integration. Trial licenses should be provided to customers who are on 2-4 week trials of your software. Paid licenses identify the end customer as a payig

## Custom License Fields
[Custom license fields](/kb/developer-resources/custom-license-fields) can be set for all licenses. This is useful if specific customer information might change from customer to customer. These fields can be read from both the [template functions](/packaging-an-application/template-functions) as well as from the [Integetration API](/reference/integration-api). Examples of custom license fields are "seats" to limit the number of active users or "hostname" in order to specify the domain that the application can be run on.
