FROM openjdk:17
EXPOSE 8080
ADD target/nanarh1/myapp.jar nanarh1/myapp.jar
ENTRYPOINT ["java", "-jar", "/nanarh1/myapp.jar"]
