+++
date = "2017-03-16T04:02:20Z"
title = "Expiration"
description = "Create New License - Expiration"
weight = "206"
+++

The expiration date and policy allow you to control what happens when the license expires. You are not required to set an expiration date, but if you do you must choose a policy.

**Ignore**

*Allow your application to continue to run and allow updates, the license will show as expired in the onprem license page.*

**Prevent Updates & Do Not Restart**

*Your application will continue to run but if stopped then it cannot be restarted. Application updates are not allowed and will prompt the user that the license is expired.*

**Prevent Updates & Stop All Containers**

*Your application will stop running on the expiration date and any attempts at updating or starting your application will inform your user that the license is expired.*

The expiration date and policy can be updated in vendor web at any time. By default online Replicated installs will sync the license with Replicated once every 5 hours.

Airgap installations do not sync with Replicated in the cloud, to update your customers license you must update the license expiration date and policy and send your customer the updated license which they can then install via onprem console.
