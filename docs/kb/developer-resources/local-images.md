+++
date = "2016-07-01T00:00:00Z"
lastmod = "2016-07-01T00:00:00Z"
title = "Speed Up Development By Using Local Images"
weight = "999999"
categories = [ "Knowledgebase", "Developer Resources" ]
+++

Shorten the development workflow of iterating on your container images:

1. Enable `bypass_local_registry: true` in your yaml app properties: http://docs.replicated.com/v1.0/docs/properties
1. Use a tag like "dev" for your image & YAML reference to the image (just don't use "latest" & don't increment the tag as you update your image).
1. Do a docker build of the image on the same machine that is running the Replicated agent daemon. **Note: This will only work for public images. See below for third party private as well as Replicated private registry images.**

This should use the new image & remove the need to push & pull. However, we don't clean up old images like this, so you might run out of disk space if you don't clean these old images up frequently (the age old Docker problem).
