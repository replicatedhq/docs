+++
date = "2016-07-01T00:00:00Z"
lastmod = "2016-07-01T00:00:00Z"
title = "Generate an API Token"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

To interact with the [vendor API](/reference/vendor-api/)
(anything that is available in the vendor web portal is available in the API) you’ll need to create API tokens.  API tokens identify your team and depending on your needs the API token can be read or read/write.  Using the API you can automate most of your development and license issuing workflows.

After you have created your API token use it in the `Authorization` header for vendor API calls.

```
curl --header "Authorization: API-TOKEN" https://api.replicated.com/vendor/v2/licenses
```

To create an API token you use your http://vendor.replicated.com/team page.


![Generate API Token](/static/generate-token.png)
