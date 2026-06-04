#!/bin/bash
##### Adding Left Items #####
# We add some regular items to the left side of the bar, where
# only the properties deviating from the current defaults need to be set

sketchybar --add item front_app left \
  --set front_app background.color=$ITEM_BG_COLOR \
  icon.color=$BLACK \
  icon.font="sketchybar-app-font:Regular:16.0" \
  label.color=$BLACK \
  icon.drawing=off \
  script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
