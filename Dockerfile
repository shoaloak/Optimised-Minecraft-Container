FROM ghcr.io/graalvm/jdk:ol9-java17-22.3.0-b2@sha256:3e8aba5280c37d0ea1c4d05b7d08bf3ff2ae0fb31ee496f6e62729ae741630e7

ARG user=minecraft
WORKDIR /opt/minecraft
COPY data/ .

RUN mkdir cache && printf "eula=true" > eula.txt \
	&& curl -o paper.jar https://api.papermc.io/v2/projects/paper/versions/1.19.4/builds/540/downloads/paper-1.19.4-540.jar \
	&& curl -o cache/mojang_1.19.4.jar https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar \
	&& groupadd -r $user && useradd -r -g $user $user && chown -R $user /opt/minecraft
EXPOSE 25565/tcp
USER $user
entrypoint ./run.sh
