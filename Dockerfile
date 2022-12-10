FROM ghcr.io/graalvm/jdk:ol9-java17-22.3.0-b2@sha256:3e8aba5280c37d0ea1c4d05b7d08bf3ff2ae0fb31ee496f6e62729ae741630e7
WORKDIR /opt/minecraft
ARG user=steve
COPY server.properties .
COPY whitelist.json .
RUN mkdir cache && printf "eula=true" > eula.txt \
	&& curl -o paper.jar https://api.papermc.io/v2/projects/paper/versions/1.19.2/builds/307/downloads/paper-1.19.2-307.jar \
	&& curl -o cache/mojang_1.19.2.jar https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar \
	&& groupadd -r $user && useradd -r -g $user $user && chown -R $user /opt/minecraft
EXPOSE 25565/tcp
USER $user
CMD java -Xms2G -Xmx6G -jar paper.jar --nogui
