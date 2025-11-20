# Stage 1: Build the JAR
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app

# Copy Maven files first (for better caching)
COPY pom.xml .
COPY mvnw mvnw.cmd ./
COPY .mvn .mvn

# Make mvnw executable
RUN chmod +x mvnw

# Copy source code and build JAR
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime image (smaller)
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copy the built JAR from builder stage
COPY --from=builder /app/target/stadium-rewarding.jar app.jar

EXPOSE 8108
ENTRYPOINT ["java", "-jar", "app.jar"]
