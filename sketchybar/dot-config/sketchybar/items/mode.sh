#!/bin/bash
#
# sketchybar --add item front_app left \
#   --set front_app background.color=$ACCENT_COLOR \
#   icon.color=$BAR_COLOR \
#   icon.font="sketchybar-app-font:Regular:16.0" \
#   label.color=$BAR_COLOR \
#   script="$PLUGIN_DIR/front_app.sh" \
#   --subscribe front_app front_app_switched

# Show which skhdrc mode we're in
sketchybar --add item skhd_mode left \
  --set skhd_mode background.color=$ACCENT_COLOR \
  icon.color=$BAR_COLOR \
  icon.font="sketchybar-app-font:Regular:16.0" \
  label.color=$BAR_COLOR \
  script="$PLUGIN_DIR/update_mode.sh" \
  --subscribe skhd_mode skhd_mode_change
sketchybar --trigger skhd_mode_change INFO="NORMAL"
