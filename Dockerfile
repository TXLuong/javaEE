# Use the official Maven image as a parent image
FROM maven:3.8.3-openjdk-11-slim AS build

# Set the working directory to /app
WORKDIR /app

# Copy the pom.xml file into the container at /app
COPY pom.xml .

# Download all required dependencies into the container
RUN mvn dependency:go-offline

# Copy the source code into the container at /app
COPY src ./src

# Build the application using Maven
RUN mvn package

# Use the official Tomcat 9 image as a parent image
FROM tomcat:9-jdk11

# Remove the default webapps that come with Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file into the container at /usr/local/tomcat/webapps
COPY --from=build /app/target/java-web-project.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 to the outside world
EXPOSE 8080

# Start Tomcat when the container starts
CMD ["catalina.sh", "run"]
