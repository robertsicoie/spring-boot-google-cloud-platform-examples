#!/usr/bin/env bash

#
# Deploy API
#
# Dependencies:
# - openapi.yaml - OpenAPI configuration file.

usage() { echo "Usage: $0 -a <create | delete> -p <project_id> " 1>&2; exit 1; }

create() {
    sed -E "s/YOUR-PROJECT-ID/example-dot-$PROJECT_ID/" openapi.yaml > /tmp/openapi.yaml

    gcloud endpoints services deploy /tmp/openapi.yaml --quiet
}

delete() {
    gcloud endpoints services delete example-dot-$PROJECT_ID.appspot.com --quiet
}



while getopts a:p:z: option
do
    case "${option}"
    in
        a) ACTION=${OPTARG};;
        p) PROJECT_ID=${OPTARG};;
        *) usage;;
    esac
done

REGION=europe-west2
ZONE=europe-west2-b

if [[ "$ACTION" == "create" ]]
then
    create;
elif [[ "$ACTION" == "delete" ]]
then
    delete;
else
    echo "Unknown action";
fi
