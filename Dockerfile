FROM openjdk:11 AS fatclinic
ADD fatclinic.tar / 
WORKDIR  /fatclinic 
RUN ./mvnw clean install

FROM tomcat:9.0-jdk17
ADD server.xml /usr/local/tomcat/conf
COPY --from=fatclinic /fatclinic/target/petclinic.war /usr/local/tomcat/webapps
