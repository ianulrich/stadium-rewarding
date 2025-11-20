# Dockerfile – Stadium Rewarding App
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy the JAR
COPY target/stadium-rewarding.jar app.jar

EXPOSE 8108

ENTRYPOINT ["java", "-jar", "app.jar"]
