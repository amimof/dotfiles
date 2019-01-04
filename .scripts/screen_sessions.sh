#!/usr/bin/env bash

# Checks if any dead screen sessions are found. Lists them and asks for
# a user action. Create an alias to this script for conveniance.
# This is useful when you only want 1 screen session at all times.

SCREENS=$(screen -list | grep Dead)
OPTIONS=("Wipe and start new" "Just start new and leave the active sessions alone")

if [[ -n $SCREENS ]]; then
    echo "There are active screens: "
    echo -e " $SCREENS \n"

    select opt in "${OPTIONS[@]}" "Quit"; do
        case $REPLY in
            1)
                echo "Wiping ALL screens"
                screen -wipe
                echo "Starting a new screen"
                screen -R
                break
                ;;
            2)
                echo "Starting a new screen, re-attaching if possible"
                screen -R
                break
                ;;
            3)
                echo "Exiting."
                break
                ;;
            *)
                echo "Invalid option"
                continue
                ;;
        esac
    done
else
    screen -R
fi
