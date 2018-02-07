Deploy Spring Boot web application to Google Cloud App Engine Flexible
===========================================================================

#### Purpose
The purpose of this README is to show how to deploy a Spring Boot web application to GCP App Engine Flexible.
This application was created by running
```
curl https://start.spring.io/starter.tgz -d packaging=jar \ 
 -d dependencies=web -d baseDir=spring-boot-containerized  \
 -d packageName=ro.robertsicoie.kubernetes | tar -xzvf -
```
and then adding a `@GetMapping` endpoint.

#### Prerequisites setup
First, you must have a GCP account.

Then install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstarts) 

#### Deploy scripts

Use ```app-engine-flexible.sh``` to deploy or undeploy to Compute Engine.

#### Cleanup

TODO