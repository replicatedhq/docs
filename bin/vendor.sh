#!/bin/bash
## Build the vendor documentation with swagger

rm -f .local/app_name
rm -f .local/tmp_swagger.json
rm -f .local/tmp_adoc.adoc
rm -f site/content/reference/vendor-api.adoc

page_metadata() {
    if [ "$1" = "apps" ]; then
        CAPS_API="Manage Apps"
        DESCRIPTION="Create, update and delete apps."
        KEYWORDS="applications, apps"
        WEIGHT="510"
    elif [ "$1" = "audit" ]; then
        CAPS_API="Audit Logs"
        DESCRIPTION="Send audit logs through Replicated."
        KEYWORDS="audit logs"
        WEIGHT="511"
    elif [ "$1" = "auth" ]; then
        CAPS_API="Authentication"
        DESCRIPTION="Login, logout and create team members."
        KEYWORDS="authentication"
        WEIGHT="512"
    elif [ "$1" = "branding" ]; then
        CAPS_API="Custom Branding"
        DESCRIPTION="Brand the Replicated user experience."
        KEYWORDS="brand, branding"
        WEIGHT="513"
    elif [ "$1" = "channels" ]; then
        CAPS_API="Manage Channels"
        DESCRIPTION="Create, update, delete, and archive channels."
        KEYWORDS="channels"
        WEIGHT="514"
    elif [ "$1" = "license" ]; then
        CAPS_API="Manage Licenses"
        DESCRIPTION="Create, update, delete, revoke licenses and download license keys."
        KEYWORDS="license, licenses"
        WEIGHT="515"
    elif [ "$1" = "releases" ]; then
        CAPS_API="Manage Releases"
        DESCRIPTION="Create, list, promote, update and archive releases."
        KEYWORDS="license, licenses"
        WEIGHT="516"
    else
        CAPS_API=""
        DESCRIPTION=""
        KEYWORDS=""
        WEIGHT=""
    fi
}

mkdir -p site/content/reference/vendor-api

for name in apps audit auth branding channels license releases ; do
    echo "Downloading ${VENDOR_API}/v1/spec/$name.json"
    curl -o .local/tmp_swagger.json ${VENDOR_API}/v1/spec/$name.json
    java -cp .local/swagger2markup-1.3.1.jar -jar .local/swagger2markup-cli-1.3.1.jar convert -i .local/tmp_swagger.json -f .local/tmp_swagger
    page_metadata $name
    OUTPUT_FILE="site/content/reference/vendor-api/$name.adoc"
    cat <<EOM >$OUTPUT_FILE
+++
date = "2016-07-03T04:02:20Z"
title = "$CAPS_API"
type = "swagger"
description = "$DESCRIPTION"
keywords= "$KEYWORDS"
weight = "$WEIGHT"
categories = [ "Vendor API" ]
+++
EOM
    cat .local/tmp_swagger.adoc >> $OUTPUT_FILE
    rm -f .local/tmp_swagger.json
    rm -f .local/tmp_adoc.adoc
done

exit 0
