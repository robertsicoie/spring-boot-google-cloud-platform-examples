Google App Engine standard environment and Google Datastore example
===================================================================

This is a sample app to demonstrate how to setup a Spring boot application for Google Cloud Platform.

#### Prerequisite
In order to run this application or setup your own application to run on Google App Engine, you must have a Google account and a Billing Account associated to this Google account.

#### Setup
Install [Java SE 8 SDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html) if you haven't already installed it.

Install [Google Cloud SDK](https://cloud.google.com/sdk/docs/).

Install App Engine Java component:
```
gcloud components install app-engine-java
```

Setup your project:
```
gcloud config set project <PROJECT_ID>
```
PROJECT_ID is the id of the project you have created in Google Cloud Console. You must enable billing on this project to deploy to it.


Authorize your account
```
gcloud auth application-default login
```

#### How to adapt for Google App Engine
There are a few steps you need to follow to adapt and deploy a simple Spring Boot web application to Google App Engine

First, update ```pom.xml``` to include Google Cloud Platform plugin that simplifies the deployment process.   
```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" ...>
  ...
  <build>
    <plugins>
      ...
      <plugin>
        <groupId>com.google.cloud.tools</groupId>
        <artifactId>appengine-maven-plugin</artifactId>
        <version>1.3.1</version>
      </plugin>
      ...
    </plugins>
  </build>
</project>
```  

Spring Boot includes Tomcat in the war package, but App Engine Standard uses Jetty web server underneath. To avoid conflicts exclude Tomcat from Spring Boot Starter and add Servlet API as a provided dependency. 
```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" ...>
  ...
  <dependencies>
    
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
      <exclusions>
        <exclusion>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-starter-tomcat</artifactId>
        </exclusion>
      </exclusions>
    </dependency>
    
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>3.1.0</version>
      <scope>provided</scope>
    </dependency>
    
  </dependencies>
</project>
```

Exclude JUL to SLF4J Bridge
```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" ...>
  ...
  <dependencies>
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>jul-to-slf4j</artifactId>
      <scope>provided</scope>
    </dependency>
  </dependencies>
</project>
```

To use Google Cloud Datastore API update ```pom.xml``` to include the appengine-api-1.0-sdk. You can find the latest available version on [Maven Central](https://mvnrepository.com/artifact/com.google.appengine/appengine-api-1.0-sdk)
```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" ...>
  ...
  <dependencies>
    <dependency>
      <groupId>com.google.appengine</groupId>
      <artifactId>appengine-api-1.0-sdk</artifactId>
      <version>1.9.60</version>
    </dependency>
  </dependencies>
</project>
```

Then you need to create a new descriptor file ```src/main/webapp/WEB-INF/appengine-web.xml``` to deploy the application into Google App Engine standard.
```
<appengine-web-app xmlns="http://appengine.google.com/ns/1.0">
  <version>1</version>
  <threadsafe>true</threadsafe>
  <runtime>java8</runtime>
</appengine-web-app>
```

These are the only changes you need to do to deploy your Spring boot application in Google App Engine. 
```DatastoreUserDao``` demonstrates how to insert and how to use the  


#### Run
To run locally
```
mvn clean -DskipTests appengine:run
```
It will start the application on port 8080. It will create a local Datastore.

To deploy on GCP
```
mvn clean -DskipTests appengine:deploy
```
If you run this sample with the ```DatastoreUserDao``` (default) you must first create a ```User``` entity type from the [console](https://console.cloud.google.com/datastore/) with the following properties:
- ip: String
- date: Date and time
- agent: String
For more details on how to create a datastore checkout Google Cloud Datastore [documentation](https://cloud.google.com/datastore/docs/quickstart).


#### Credits
This project was setup based on the Google Developers [article](https://codelabs.developers.google.com/codelabs/cloud-app-engine-springboot) for deploying Spring Boot applications in App Engine, and other Google Cloud resources.

