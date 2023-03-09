#!/bin/sh

readonly CONTAINER_ID=`podman ps | grep minecraft | awk '$1 { print $1 }'`
readonly RCON_CMD="podman exec -it $CONTAINER_ID mcrcon/mcrcon -p ImInsideTheContainer"

# ensure that saves folder exists
if [ ! -d saves ]; then
  mkdir saves
fi

backup() {
    echo "Backing up world..."
    $RCON_CMD "say Creating server backup in 5 seconds."
    sleep 5
    epoch=`date +%s`
    $RCON_CMD save-off
    sleep 1
    $RCON_CMD save-all
    sleep 3
    podman exec -it $CONTAINER_ID tar -cf $epoch.tar world world_nether world_the_end
    podman cp $CONTAINER_ID:$epoch.tar /tmp/
    podman exec -it $CONTAINER_ID rm $epoch.tar
    yes | gzip /tmp/$epoch.tar
    mv /tmp/$epoch.tar.gz saves/
    $RCON_CMD save-on
    $RCON_CMD "say Done with backup!"
}


main() {
    PS3='What would you like to do: '
    options=("Start" "Restart" "Kill" "Shell" "RCON" "Backup" "Restore" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Start")
                echo "Starting container..."
                podman run -d --cpus=4 --memory=6g -p 25565:25565 minecraft
                break
                ;;
            "Restart")
                echo "Restarting server..."
                $RCON_CMD "say Server is going down in 5 seconds."
                sleep 5
                $RCON_CMD save-all
                sleep 1
                $RCON_CMD stop
                ;;
            "Kill")
                echo "Killing container..."
                $RCON_CMD "say Server is going down in 5 seconds."
                sleep 5
                podman kill $CONTAINER_ID 
                break
                ;;
            "Shell")
                echo "Starting shell..."
                podman exec -it $CONTAINER_ID /bin/bash
                break
                ;;
            "RCON")
                echo "Connecting with RCON..."
                $RCON_CMD
                break
                ;;
            "Backup")
                backup
                ;;
            "Restore")
                if [ -n "$(ls -A saves 2>/dev/null)" ]
                then
                    echo "Restoring most recent backup..."
                    backup=`ls -Art saves | tail -n 1`
                    tar=`echo "${backup%.*}"`
                    cp saves/$backup /tmp/
                    yes | gunzip /tmp/$backup
                    $RCON_CMD stop
                    sleep 2
                    podman cp /tmp/$tar $CONTAINER_ID:.
                    podman exec -it $CONTAINER_ID tar -xf $tar
                    rm /tmp/$tar
                    break
                else
                    echo "no backups!"
                fi
                ;;
            "Quit")
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}

if [[ $# -ne 0 ]]; then
    arg="$1"
    case "$arg" in
        backup)
            backup
            exit 0
            ;;
        *)
            echo "unrecognised"
            exit -1
            ;;
    esac
fi
main "$@"
