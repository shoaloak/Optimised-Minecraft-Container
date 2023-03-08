#!/bin/sh

readonly CONTAINER_ID=`podman ps | grep minecraft | awk '$1 { print $1 }'`

PS3='What would you like to do: '
options=("Shell" "RCON" "Quit")
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
            podman exec -it $CONTAINER_ID mcrcon/mcrcon -p ImInsideTheContainer
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

