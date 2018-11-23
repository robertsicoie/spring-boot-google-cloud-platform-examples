#!/usr/bin/env bash

#
# Build jar file, copy it to Cloud Storage and deploy a single Compute Engine instance.
#

create_instance() {
    mvn package

    gsutil mb gs://${BUCKET}
    gsutil cp ./target/${JAR} gs://${BUCKET}/${JAR}

    gcloud compute firewall-rules create ${VM}-http --allow tcp:80 --target-tags ${VM}


    gcloud compute instances create ${VM} \
      --tags ${VM} \
      --zone $ZONE --machine-type n1-standard-1 \
      --metadata-from-file startup-script=startup.sh
}

delete_instance() {
    gsutil rm -r gs://${BUCKET}
    gcloud compute firewall-rules delete ${VM}-http
    gcloud compute instances delete ${VM} --zone $ZONE
}

while getopts a:p:z: option
do
    case "${option}"
    in
        a) ACTION=${OPTARG};;
        p) PROJECT_ID=${OPTARG};;
        z) ZONE=${OPTARG};;
        *) usage;;
    esac
done

REGION=europe-west2
ZONE=europe-west2-b
BUCKET=spring-boot-single-node
JAR=spring-boot-containerized-0.0.1-SNAPSHOT.jar
VM=spring-boot-single-node



if [ "$ACTION" == "create" ]
then
    create_instance;
elif [ "$ACTION" == "delete" ]
then
    delete_instance;
else
    echo "Unknown action";
fi