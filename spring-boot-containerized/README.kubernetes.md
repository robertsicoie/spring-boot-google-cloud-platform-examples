Deploy Spring Boot web application to Google Cloud Kubernetes Engine
===========================================================================

#### Purpose
The purpose of this README is to show how to deploy a Spring Boot web application to GCP Kubernetes Engine.
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

Next, from your shell or terminal install `kubectl`:
```
gcloud components install kubectl
```

Install [Docker](https://docs.docker.com/install/). 

Build image and push it to [Container Registry](README.docker.md).

#### Deploy the image on Kubernetes

Set the default project, by replacing `[PROJECT-ID]` with your project ID.
```
gcloud config set project [PROJECT-ID]
```

Set default compute zone, by replacing `[COMPUTE-ZONE]` with the desired geographical compute zone, for example `us-west1-a`
```
gcloud config set compute/zone [COMPUTE-ZONE]
```

Create the cluster
```
gcloud container clusters create [CLUSTER-NAME]
```

Authenticate credentials to interact with the cluster
```
gcloud container clusters get-credentials [CLUSTER-NAME]
```

Create the docker image
```bash
docker build -t gcr.io/[PROJECT]/[IMAGE]:[VERSION] .
```
Authenticate to container registry
```bash
gcloud auth configure-docker
```
Upload the image
```bash
docker push gcr.io/[PROJECT]/[IMAGE]:[VERSION]
```

Run the application in the cluster
```
kubectl run spring-boot-containerized --image=[HOSTNAME]/[PROJECT-ID]/[IMAGE]:[VERSION] --port 8080
```
For example:
```
kubectl run spring-boot-containerized --image=gcr.io/my-project/spring-boot-containerized:latest --port 8080
```
Create a Kubernetes Service to expose the application to external traffic.
```
kubectl expose deployment service spring-boot-containerized --type="LoadBalancer" --port=80 --target-port=8080
```

Inspect the service by running
```
kubectl get service spring-boot-containerized
```

Open in browser
http://[EXTERNAL-IP]

#### Scale
Scale from one to 3 replicas of the sprint-boot-containerized deployment. This will create 3 pods.
```bash
kubectl scale --replicas=3 deployment/spring-boot-containerized
```

#### Cleanup
To remove the image from Container Registry run:
```
gcloud container images delete gcr.io/[PROJECT-ID]/[IMAGE]
```

Remove the cluster
```
gcloud container clusters delete [CLUSTER-NAME]
```

Remove the instance group
```
gcloud compute instance-groups managed delete [INSTANCE-GROUP]
```

Remove the instance template
```
gcloud compute instance-templates delete [INSTANCE-GROUP-TEMPLATE]
```

#### Credits
This example is based on the [Kubernetes Engine documentation](https://cloud.google.com/kubernetes-engine)