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

## License Channel (Required)
When you create a license you'll need to assign it to a release channel (if it is a customer,
likely channel is Stable, but for your internal testing you'll also likely need unstable &
 beta licenses). (More about release channel management).

## Expiration (Required)
When you create a license you can specify how the license will behave when it expires.  The policy
can ignore expiration, allow a running application to continue but prevent updates, or stop
the running application and prevent updates.  License expiration to stop running the application is supported in Replicated 2.1.0
or newer.

## Custom License Fields (Optional)
Custom license fields can be set for all licenses. This is useful if specific customer
information might change from customer to customer. These fields can be read from both
the [template functions](/packaging-an-application/template-functions)) as well as from
the [Integetration API](/reference/integration-api). Examples of custom license fields are
"seats" to limit the number of active users or "hostname" in order to specify the domain
that the application can be run on.

## License Activation (Optional)
The license file becomes the key to download & install your application. For this reason,
it is wise to enable the [license activation feature](/kb/supporting-your-customers/two-factor-licenses)
on all licenses. This will add a simple step to your customer's installation experience,
where the email you specify will be sent an activation code required to proceed pass step 2
in the process.
