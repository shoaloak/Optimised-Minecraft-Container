# containerised GraalVM Papermc-based minecraft server

build:
`buildah build -t minecraft .`

start:
`podman run -d -p 25565:25565 minecraft`

don't forget to open your firewall :')
```
firewall-cmd --zone=public --add-port=25565/tcp --permanent
sudo firewall-cmd --reload
```
