How to deploy Spring Boot web application to Google Cloud Kubernetes Engine
===========================================================================

#### Purpose
The purpose of this example is to show how to deploy a Spring Boot web application to GCP Kubernetes Engine.
This application was created by running
```
curl https://start.spring.io/starter.tgz -d packaging=jar \ 
 -d dependencies=web -d baseDir=spring-boot-google-kubernetes-engine  \
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

Install Docker

#### Create the image
First create the jar by running:
```
mvn package
```

Build the docker image:
```
docker build -t spring-boot-kubernetes .
```

Tag your image, to push it to [Google Cloud Container Registry](https://cloud.google.com/container-registry/)
The registry name format is `[HOSTNAME]/[PROJECT-ID]/[IMAGE]` where:
 - `[HOSTNAME]` is the gcr.io hostname
 - `[PROJECT-ID]` is your Google Cloud Platform Console project ID
 - `[IMAGE]` is your image's name
Run
```
docker tag [IMAGE] [HOSTNAME]/[PROJECT-ID]/[IMAGE]
```
to tag your Docker image. For example:
```
docker tag spring-boot-kubernetes gcr.io/my-project/spring-boot-kubernetes
```

To push your image to Container Registry, run:
```
gcloud docker -- push [HOSTNAME]/[PROJECT-ID]/[IMAGE]
```
for example:
```
gcloud docker -- push gcr.io/my-project/spring-boot-kubernetes
```


#### Test image
To test locally that your image works as expected, pull it from Container Registry and run it locally.
To pull it run:
```
gcloud docker -- pull [HOSTNAME]/[PROJECT-ID]/[IMAGE]
```

To run an it:
```
docker run -p 80:8080 [HOSTNAME]/[PROJECT-ID]/[IMAGE]
```

#### Deploy the image

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

Authenticate credentials to intereact with the cluster
```
gcloud container clusters get-credentials [CLUSTER-NAME]
```

Run the application in the cluster
```
kubectl run spring-boot-kubernetes --image=[HOSTNAME]/[PROJECT-ID]/[IMAGE]:[VERSION] --port 8080
```
For example:
```
kubectl run spring-boot-kubernetes --image=gcr.io/my-project/spring-boot-kubernetes:latest --port 8080
```
Create a Kubernetes Service to expose the application to external traffic.
```
kubectl expose deployment service spring-boot-kubernetes --type="LoadBalancer" --port=80
```

Inspect the service by running
```
kubectl get service spring-boot-kubernetes
```

Open in browser
http://[EXTERNAL-IP]:8080


#### Cleanup
To remove the image from Container Registry run:
```
gcloud container images delete [HOSTNAME]/[PROJECT-ID]/[IMAGE]
```

Remove the cluster
```
gcloud container clusters delete [CLUSTER-NAME]
```

#### Credits
This example is based on the [Kubernetes Engine documentation](https://cloud.google.com/kubernetes-engine)