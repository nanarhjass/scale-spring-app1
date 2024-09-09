FROM jdk17
ADD target/*.jar $APP_HOME/app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
