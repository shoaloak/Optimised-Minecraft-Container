# Containerised GraalVM Papermc-based minecraft server
Gotta go fast!

## Execution
build:
`buildah build -t minecraft .`

start:
`podman run -d -p 25565:25565 minecraft`

don't forget to open your firewall :')
```
sudo firewall-cmd --zone=public --add-port=25565/tcp --permanent
sudo firewall-cmd --reload
```

## Plugins
We use [No Chat Reports](https://www.spigotmc.org/resources/no-chat-reports.102990/).
The `paper-workaround` is disabled since [issue](https://github.com/teakivy/NoChatReports/issues/6)
