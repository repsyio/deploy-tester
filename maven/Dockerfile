FROM maven:3.9-eclipse-temurin-8

COPY deploy /opt/deploy
COPY use /opt/use
COPY entrypoint.sh /

ENTRYPOINT /entrypoint.sh
