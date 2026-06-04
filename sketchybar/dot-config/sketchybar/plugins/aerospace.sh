#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.drawing=on \
    background.color=$ITEM_BG_COLOR \
    label.color=$BLACK \
    icon.color=$BLACK

else
  sketchybar --set $NAME background.drawing=off \
    label.color=$WHITE \
    icon.color=$WHITE

fi
