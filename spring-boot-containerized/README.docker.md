Working with Docker and Google Cloud Container Registry  
=======================================================

#### Create the image
First create the jar by running:
```
mvn package
```

Build the docker image:
```
docker build -t spring-boot-containerized .
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
docker tag spring-boot-containerized gcr.io/my-project/spring-boot-containerized
```

To push your image to Container Registry, run:
```
gcloud docker -- push [HOSTNAME]/[PROJECT-ID]/[IMAGE]
```
for example:
```
gcloud docker -- push gcr.io/my-project/spring-boot-containerized
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

#### Cleanup
To remove the image from Container Registry run:
```
gcloud container images delete [HOSTNAME]/[PROJECT-ID]/[IMAGE]
```

