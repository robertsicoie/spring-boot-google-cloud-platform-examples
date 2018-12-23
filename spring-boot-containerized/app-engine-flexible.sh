#!/usr/bin/env bash

#
# Build jar file and deploy to App Engine Flexible
#
# Dependencies:
# - app.yaml - Specify the configuration for the application.
# - Dockerfile - Defines the set of instructions to create the Docker image.

usage() { echo "Usage: $0 -a <create | delete> -p <project_id> " 1>&2; exit 1; }

create() {
    mvn clean package

    gcloud config set project $PROJECT_ID

    gcloud app create --region $REGION --quiet

    gcloud app deploy --quiet

    gcloud app browse --quiet
}

delete() {
    gcloud app services delete example --quiet
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

if [ "$ACTION" == "create" ]
then
    create;
elif [ "$ACTION" == "delete" ]
then
    delete;
else
    echo "Unknown action";
fi
