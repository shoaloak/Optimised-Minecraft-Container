#!/bin/sh

readonly CONTAINER_ID=`podman ps | grep minecraft | awk '$1 { print $1 }'`
readonly RCON_CMD="podman exec -it $CONTAINER_ID mcrcon/mcrcon -p ImInsideTheContainer"

PS3='What would you like to do: '
options=("Shell" "RCON" "Shutdown" "Quit")
select opt in "${options[@]}"
do
    case $opt in
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
        "Shutdown")
            echo "Stopping server..."
            $RCON_CMD "say Server is going down in 5 seconds"
            sleep 5
            $RCON_CMD save-all
            sleep 1
            $RCON_CMD stop
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

