FROM anapsix/alpine-java

COPY target/spring-boot-containerized-0.0.1-SNAPSHOT.jar /home/spring-boot-containerized-0.0.1-SNAPSHOT.jar

EXPOSE 8080

CMD ["java", "-jar", "/home/spring-boot-containerized-0.0.1-SNAPSHOT.jar"]