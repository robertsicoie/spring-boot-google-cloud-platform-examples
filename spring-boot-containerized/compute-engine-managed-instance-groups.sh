#!/usr/bin/env bash

#
# Create or delete instance template, instance-groups, load balancer and firewall rule.
#
# See usage.

JAR=spring-boot-containerized-0.0.1-SNAPSHOT.jar

usage() { echo "Usage: $0 -a <create | delete> -p <project_id> -z <zone> " 1>&2; exit 1; }

create_cluster() {
    gcloud config set project $PROJECT_ID

    gcloud config set compute/zone $ZONE

    gsutil mb gs://${BUCKET}

    gsutil cp ./target/${JAR} gs://${BUCKET}/${JAR}

#    gcloud beta compute instance-templates create-with-container $INSTANCE_TEMPLATE_NAME \
#      --container-image gcr.io/$PROJECT_ID/$IMAGE_NAME


    gcloud compute firewall-rules create ${BASE_INSTANCE_NAME}-www \
        --allow tcp:80 \
        --target-tags ${BASE_INSTANCE_NAME}

    gcloud compute health-checks create http ${BASE_INSTANCE_NAME}-check --port 80 \
        --check-interval 30s \
        --healthy-threshold 1 \
        --timeout 10s \
        --unhealthy-threshold 3

    gcloud compute firewall-rules create allow-health-check \
        --allow tcp:80 \
        --source-ranges 130.211.0.0/22,35.191.0.0/16 \
        --network default

    gcloud compute instance-templates create $INSTANCE_TEMPLATE_NAME \
        --machine-type n1-standard-4 \
        --image-family debian-9 \
        --image-project debian-cloud \
        --tags ${BASE_INSTANCE_NAME} \
        --metadata-from-file startup-script=startup.sh

    gcloud compute instance-groups managed create $INSTANCE_GROUP_NAME \
        --base-instance-name $BASE_INSTANCE_NAME \
        --size 2 \
        --template $INSTANCE_TEMPLATE_NAME

    gcloud beta compute instance-groups managed set-autohealing $INSTANCE_GROUP_NAME  \
        --health-check ${BASE_INSTANCE_NAME}-check \
        --initial-delay 120 \
        --zone $ZONE

    gcloud compute backend-services create ${BASE_INSTANCE_NAME}-backend \
        --health-checks ${BASE_INSTANCE_NAME}-check \
        --global \
        --protocol HTTP

    gcloud compute url-maps create ${BASE_INSTANCE_NAME}-map \
        --default-service ${BASE_INSTANCE_NAME}-backend

    gcloud compute target-http-proxies create ${BASE_INSTANCE_NAME}-lb-proxy \
        --url-map ${BASE_INSTANCE_NAME}-map

    gcloud compute addresses create ${BASE_INSTANCE_NAME}-lb-ip-cr \
        --ip-version=IPV4 \
        --global

    lb_ip_address=`gcloud compute addresses list | grep ${BASE_INSTANCE_NAME}-lb-ip-cr | tr -s ' ' | cut -d' ' -f2`

    gcloud compute forwarding-rules create  ${BASE_INSTANCE_NAME}-http-cr-rule \
        --address $lb_ip_address \
        --global \
        --target-http-proxy ${BASE_INSTANCE_NAME}-lb-proxy \
        --ports 80
}

delete_cluster() {

    gsutil rm -r gs://${BUCKET}

    gcloud config set project $PROJECT_ID

    gcloud config set compute/zone $ZONE

    gcloud compute target-http-proxies delete ${BASE_INSTANCE_NAME}-lb-proxy --quiet

    gcloud compute addresses delete ${BASE_INSTANCE_NAME}-lb-ip-cr --global --quiet

    gcloud compute url-maps delete ${BASE_INSTANCE_NAME}-map --quiet

    gcloud compute backend-services delete ${BASE_INSTANCE_NAME}-backend --global --quiet

    gcloud compute health-checks delete http ${BASE_INSTANCE_NAME}-check --quiet

    gcloud compute forwarding-rules delete  ${BASE_INSTANCE_NAME}-http-cr-rule --global --quiet

    gcloud compute firewall-rules delete ${BASE_INSTANCE_NAME}-www --quiet

    gcloud compute firewall-rules delete allow-health-check --quiet

    gcloud compute instance-groups managed delete $INSTANCE_GROUP_NAME --quiet

    gcloud compute instance-templates delete $INSTANCE_TEMPLATE_NAME --quiet


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

IMAGE_NAME=spring-boot
INSTANCE_TEMPLATE_NAME=spring-boot
BASE_INSTANCE_NAME=spring-boot-vm
INSTANCE_GROUP_NAME=spring-boot-group
REGION=europe-west1
ZONE=europe-west1-b
BUCKET=spring-boot-http

if [ "$ACTION" == "create" ]
then
    create_cluster;
elif [ "$ACTION" == "delete" ]
then
    delete_cluster;
else
    echo "Unknown action";
fi