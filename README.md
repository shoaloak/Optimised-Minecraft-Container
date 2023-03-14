# Containerised GraalVM Papermc-based minecraft server
Gotta go fast!

## Execution
build:
`buildah build -t minecraft .`

start:
`podman run -d -p 25565:25565 minecraft`

`server-cli.sh` can start, stop, backup, etc.
crontab can be useful for automatic backupping, e.g.:
`*/30 * * * * cd /home/shoaloak/src/shoaloak-minecraft && ./server-cli.sh backup`


## Troubleshooting
don't forget to open your firewall :')
```
sudo firewall-cmd --zone=public --add-port=25565/tcp --permanent
sudo firewall-cmd --reload
```

if you get `Error: OCI runtime error: crun: the requested cgroup controller `cpu` is not available`, check out [podman docs](https://github.com/containers/podman/blob/main/troubleshooting.md#26-running-containers-with-resource-limits-fails-with-a-permissions-error).


## Plugins
We use [No Chat Reports](https://www.spigotmc.org/resources/no-chat-reports.102990/).
The `paper-workaround` is disabled since [issue](https://github.com/teakivy/NoChatReports/issues/6)

[One Player Sleep](https://www.spigotmc.org/resources/one-player-sleep.31585/), fed up with loggin out
