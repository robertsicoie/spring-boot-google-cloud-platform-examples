Deploy Spring Boot web application to Google Cloud Compute Engine
===========================================================================

#### Purpose
The purpose of this README is to show how to deploy a Spring Boot web application to GCP Compute Engine.
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

Install [Docker](https://docs.docker.com/install/). 

Build image and push it to [Container Registry](README.docker.md).
 

#### Deploy Docker image as managed instance groups to GCP Compute Engine

Set the default project, by replacing `[PROJECT-ID]` with your project ID.
```
gcloud config set project [PROJECT-ID]
```

Set default compute zone, by replacing `[COMPUTE-ZONE]` with the desired geographical compute zone, for example `us-west1-a`
```
gcloud config set compute/zone [COMPUTE-ZONE]
```

Create an instance template to run the image on centos-7 machines 
```
 gcloud beta compute instance-templates create-with-container spring-boot-docker-with-image --container-image [HOSTNAME]/[PROJECT-ID]/spring-boot-containerized --image-family centos-7 --image-project centos-cloud
```

Create an instance group of two machines
```
gcloud compute instance-groups managed create spring-boot-group --base-instance-name spring-boot-vm --size 2 --template spring-boot-docker-with-image
```

#### Deploy scripts

Use ```compute-engine-managed-instance-groups.sh``` or ```compute-engine-single-instance.sh``` to deploy or undeploy to Compute Engine. These scripts do not use the Docker image.

#### Cleanup
To remove the image from Container Registry run:
```
gcloud container images delete [HOSTNAME]/[PROJECT-ID]/[IMAGE]
```

Remove the cluster
```
gcloud container clusters delete [CLUSTER-NAME]
```

Remove the instance group
```
gcloud compute instance-groups managed delete spring-boot-group
```

Remove the instance template
```
gcloud compute instance-templates delete spring-boot-docker-with-image
```
