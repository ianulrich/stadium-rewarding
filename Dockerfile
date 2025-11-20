# Dockerfile – Stadium Rewarding App
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

# Build the JAR (this creates target/stadium-rewarding.jar)
RUN ./mvnw clean package -DskipTests

# Final stage – small runtime image
FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY --from=builder /app/target/stadium-rewarding.jar app.jar

EXPOSE 8108
ENTRYPOINT ["java", "-jar", "app.jar"]
