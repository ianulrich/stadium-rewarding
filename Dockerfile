# Dockerfile – Stadium Rewarding App
FROM openjdk:17-jdk-slim

# Create app directory
WORKDIR /app

# Copy the built JAR (from target folder)
COPY target/stadium-rewarding.jar app.jar

# Expose port
EXPOSE 8108

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
