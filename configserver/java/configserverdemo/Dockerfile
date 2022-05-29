FROM openjdk:11.0-jdk-buster as base

WORKDIR /work

COPY mvnw /work/mvnw
COPY .mvn /work/.mvn
COPY pom.xml /work/pom.xml

RUN ./mvnw dependency:go-offline

COPY . /work/

RUN ./mvnw install
RUN chmod +x /work/target/configserverdemo-0.0.1-SNAPSHOT.jar

ENTRYPOINT ["java", "-jar", "/work/target/configserverdemo-0.0.1-SNAPSHOT.jar"]