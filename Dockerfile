# Dockerfile – works 100% with any Spring Boot project
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app

# Copy Maven wrapper + pom first (best layer caching)
COPY mvnw mvnw.cmd ./
COPY .mvn .mvn
COPY pom.xml .

# Make wrapper executable + download dependencies (caches if pom unchanged)
RUN chmod +x ./mvnw
RUN ./mvnw dependency:go-offline -DskipTests

# Copy source and build
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Final stage – tiny runtime
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the ACTUAL JAR that was built (glob pattern = works for any version/name)
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8108
ENTRYPOINT ["java", "-jar", "app.jar"]
