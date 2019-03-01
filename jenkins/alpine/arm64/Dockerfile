FROM alpine:3.9 AS installer

ARG JENKINS_VERSION="2.150.3"

RUN apk add --no-cache \
    curl \
    docker

RUN curl -SL -o jenkins.war http://mirrors.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war


# Jenkins
FROM openjdk:8-jre-alpine

RUN apk add --no-cache \
    git \
    ttf-dejavu

ARG JENKINS_VERSION="2.150.3"
ENV JENKINS_VERSION=${JENKINS_VERSION} \
    JENKINS_HOME="/data"

VOLUME ${JENKINS_HOME}

EXPOSE 8080 50000
ENTRYPOINT java -jar /jenkins/jenkins.war

COPY --from=installer /usr/bin/docker /usr/bin/docker
COPY --from=installer /jenkins.war /jenkins/jenkins.war
