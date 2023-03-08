#!/bin/sh

readonly CONTAINER_ID=`podman ps | grep minecraft | awk '$1 { print $1 }'`
readonly RCON_CMD="podman exec -it $CONTAINER_ID mcrcon/mcrcon -p ImInsideTheContainer"

# ensure that saves folder exists
if [ ! -d saves ]; then
  mkdir saves
fi

PS3='What would you like to do: '
options=("Start" "Stop" "Shell" "RCON" "Backup" "Restore" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Start")
            echo "Starting MC Server..."
            podman run -d --cpus=4 --memory=6g -p 25565:25565 minecraft
            break
            ;;
        "Stop")
            echo "Stopping server..."
            $RCON_CMD "say Server is going down in 5 seconds."
            sleep 5
            $RCON_CMD save-off
            $RCON_CMD save-all
            sleep 3
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
            echo "Backing up world..."
            epoch=`date +%s`
            $RCON_CMD "say Creating server backup in 5 seconds."
            sleep 5
            $RCON_CMD save-off
            sleep 1
            $RCON_CMD save-all
            sleep 3
            podman exec -it $CONTAINER_ID tar -cf $epoch.tar world world_nether world_the_end
            podman cp $CONTAINER_ID:$epoch.tar /tmp/
            gzip /tmp/$epoch.tar
            mv /tmp/$epoch.tar.gz saves/
            $RCON_CMD save-on
            $RCON_CMD "say Done with backup!"
            break
            ;;
        "Restore")
            if [ -n "$(ls -A saves 2>/dev/null)" ]
            then
                echo "Restoring most recent backup..."
                backup=`ls -Art saves | tail -n 1`
                tar=`echo "${backup%.*}"`
                $RCON_CMD "say Restoring server backup in 5 seconds."
                sleep 5
                cp saves/$backup /tmp/
                gunzip /tmp/$backup
                $RCON_CMD stop
                sleep 2
                podman cp /tmp/$tar $CONTAINER_ID:.
                podman exec -it $CONTAINER_ID tar -xf $tar
                rm $tar
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

