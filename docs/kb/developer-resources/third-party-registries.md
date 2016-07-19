+++
date = "2016-07-01T00:00:00Z"
lastmod = "2016-07-01T00:00:00Z"
title = "Third Party Registries"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

Replicated can now integrate with your third party private registry (ie Docker Trusted Registry, Quay.io etc). To connect to these external registries 
you'll need to connect your vendor account to these accounts on the [app settings page](https://vendor.replicated.com/#/settings).

{{< note title="Please Note" >}}
Please note that as of December 7, 2015, [Replicated will no longer support Docker Hub hosted Registry](http://blog.replicated.com/2015/12/02/docker-hub-deprecates-registry-v1/), 
due to their depreciation of registry v1 protocol support.
{{< /note >}}

You'll need to provide us with a reference name, endpoint, username, password and email address (we recommend creating a specific account for 
replicated with read-only access to use).

Your credentials will never be shared or used by the customer to pull your images, instead your images will be proxied by us for each 
installation.

To access these images in your YAML you'll need to use the reference name as the source & then the image name will need to provide the image 
name location, along with the version tag.

```yml
components:
- name: App
  containers:
  - source: mythirdpartyprivateregistry
    image_name: namespace/imagename
    version: 1.0.0
```