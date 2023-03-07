# containerised GraalVM Papermc-based minecraft server

build:
`buildah build -t minecraft .`

start:
`podman run -ti -p 25565:25565 minecraft`
