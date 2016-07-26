+++
date = "2016-07-22T00:00:00Z"
lastmod = "2016-07-22T00:00:00Z"
title = "Registries"
weight = "999999"
categories = [ "Knowledgebase", "Supporting Your Customers" ]
+++

When your customer is installing or updating your application, Replicated is responsible for pulling all required Docker images into the environment. These images can come from a variety of sources and each customer environment is a little different. Replicated makes use of various methods to securely deliver the Docker images to all of your customer's nodes, and understanding how this works can be useful with troubleshooting. 

## Replicated Images
When you use the [Replicated Docker Registry](/getting-started/replicated-private-registry/), Replicated will always use the Docker client to pull your images. The Replicated registry is a secure, private-only registry that is closely integrated with our licensing feature. Your developers and API tokens can push and pull images to and from this registry. A customer's license is used for authentication during installation and update on-prem. The customer's license credentials is only granted pull permissions to your images.

## Public Images
When your application makes use of public images, Replicated uses the Docker Remote API to pull the image. Nothing special is needed to support this, and Replicated supports this automatically.

## Private Images
Private images that are hosted on non-Replicated servers are also supported and Replicated has a new method to support these. In your YAML, you reference a private registry, and you provide Replicated the credentials to this registry. The Replicated servers never share these credentials with the on-prem installations. Our servers provide a proxy to securely deliver these external images only to licenses that you create and authorize.

When the on-prem component attempts to pull a private image, Replicated will open an HTTPS connection to a service we host. Once the connection is authenticated and verified, the Replicated proxy will stream the Docker layers and manifest to the on-prem server. The on-prem server then uses the Docker Remote API to `docker load` this image into Docker.

We currently support the Docker registry protocol version 2 and version 2.2. In current versions of Replicated, we've removed support for importing private images that only support the Docker registry protocol version 1.

