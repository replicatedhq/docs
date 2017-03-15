+++
date = "2017-03-13T00:00:00Z"
lastmod = "2017-03-13T00:00:00Z"
title = "Updating Expiration on Licenses"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

A good use case for using the VendorAPI is license maintenance. In this example you want to find all licenses that are expiring soon (<5 days) in the beta channel and extend them by a month. You are using your beta channel to ship new features to some of your customers and want to extend their access to the channel by a month while you get feedback on the new features.

## Prerequisites

You should already have an API Token set to Read/Write via the vendor site, and you should know the target App ID and Channel ID. For details on how to get the App ID and Channel ID programmatically, check out the document called [Finding Your API Token and App ID](/kb/developer-resources/finding-your-api-token-and-app-id). These values will not change and should be supplied as static values to your license updating script.

### 1) Get all outstanding licenses

First you will get all the licenses that have been issued for a specific app:

    curl -X GET \
    	 -H 'Authorization: <YOUR-API-TOKEN>' \
    	 https://api.replicated.com/vendor/v2/app/<YOUR-APP-ID>/licenses

Note, the result will contains an array of objects for all the licenses associated with this app, including all the channels.

### 2) Find expiring licenses

In your language of choice you will iterate through the returned array from step 1 and create a new array that contains all licenses where "ChannelId" fields match your Beta Channel ID. You will then iterate through the new array and look for licenses with an "ExpireDate" that is within the next five days and pop those from this array.

### 3) Update expiring licenses

You will loop through the newly created array of expiring licenses from the previous step and update each of the licenses with a date that is 30 days from now. Its important to note that the field name to update on this endpoint is "expiration_date" and that you have to pass all of the expected fields from your license object because the fields will be overwritten with default values if they are left blank.

      curl -X PUT \
      	 -H 'Authorization: <YOUR-API-TOKEN>' \
      	 -H 'Content-Type: application/json' \
      	 https://api.replicated.com/vendor/v2/license/<YOUR-LICENSE-ID> \
      	 -d '{"license_type":"dev",
              "activation_email": false,
              "airgap_download_enabled": false,
              "assignee":"My-App",
              "update_policy":"manual",
              "channel_id":"<YOUR-CHANNEL-ID>",
              "expiration_date":"2018-03-13",
              "expiration_policy":"ignore",
              "require_activation":false}'
