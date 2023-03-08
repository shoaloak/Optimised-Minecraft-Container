#/bin/sh
while true
do
    echo "Starting Minecraft server"
    java -Xms2G -Xmx6G -jar paper.jar --nogui
    echo "Server stopped, restarting within 10s..."
    sleep 10
done
