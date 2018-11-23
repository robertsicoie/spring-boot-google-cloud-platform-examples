#!/usr/bin/env bash

#
# Startup script to run on GCP Compute Engine instance creation.
#

BUCKET=spring-boot-http
JAR=spring-boot-containerized-0.0.1-SNAPSHOT.jar

sudo su -

echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install oracle-java8-installer -y --allow-unauthenticated

mkdir /opt/$BUCKET
gsutil cp gs://${BUCKET}/${JAR} /opt/$BUCKET/${JAR}
java -jar /opt/$BUCKET/${JAR} --server.port=80 &
exit
