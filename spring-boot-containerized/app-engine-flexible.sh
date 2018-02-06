#!/usr/bin/env bash

#
# Build jar file and deploy to App Engine Flexible
#
# Dependencies:
# - app.yaml - Specify the configuration for the application.
# - Dockerfile - Defines the set of instructions to create the Docker image.

mvn package

gcloud app create

gcloud app deploy

gcloud app browse


# TODO add cleanup steps.
