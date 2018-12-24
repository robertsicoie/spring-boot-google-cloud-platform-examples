Deploy Spring Boot web application to Google Cloud App Engine Flexible
===========================================================================

#### Purpose
The purpose of this README is to show how to deploy a sample API for a Spring Boot web application running on GCP App Engine Flexible.
The application was created by running
```
curl https://start.spring.io/starter.tgz -d packaging=jar \ 
 -d dependencies=web -d baseDir=spring-boot-containerized  \
 -d packageName=ro.robertsicoie.kubernetes | tar -xzvf -
```
and then a `@GetMapping` endpoint was added.

#### Prerequisites setup
First, you must have a GCP account.

Then install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstarts) 

#### Deploy scripts

Use ```endpoints.sh``` to deploy the API.

```
$ ./endpoints.sh -a create -p YOUR-PROJECT-ID

```

Then [deploy the application](README.app-engine-flexible.md)

The application will be available at `https://example-dot-YOUR-PROJECT-ID.appspot.com`

You can use [Cloud Endpoints Portal](https://cloud.google.com/endpoints/docs/openapi/dev-portal-overview) to create a developer portal for interacting with the API.  
 
#### Cleanup
```
$ ./endponts.sh -a delete -p YOUR-PROJECT-ID

```
Then [delete the application](README.app-engine-flexible.md) 
