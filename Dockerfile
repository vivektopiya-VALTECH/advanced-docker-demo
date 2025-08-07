FROM eclipse-temurin:24
COPY target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]