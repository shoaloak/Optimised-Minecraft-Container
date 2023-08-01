FROM ghcr.io/graalvm/jdk:ol9-java17-22.3.2

ARG user=minecraft
WORKDIR /opt/minecraft
COPY data/ .

RUN mkdir cache && printf "eula=true" > eula.txt \
    && curl -o paper.jar https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/100/downloads/paper-1.20.1-100.jar \
    && curl -o cache/mojang_1.20.1.jar https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar \
    && groupadd -r $user && useradd -r -g $user $user && chown -R $user /opt/minecraft
EXPOSE 25565/tcp
USER $user
entrypoint ./run.sh
