sketchybar --add item wifi right \
  --set wifi \
  script="$PLUGIN_DIR/wifi.sh" \
  --subscribe wifi wifi_change \
  --subscribe wifi mouse.clicked

# Hammerspoon-based updates
# sketchybar --add event wifi_ssid_changed
# sketchybar --add item wifi right \
#   --subscribe space.$sid wifi_ssid_changed \
#   --set wifi \
#   icon= icon.color=0xFFFEFEFE \
#   script="$CONFIG_DIR/plugins/aerospace.sh $sid" # label="$sid" \
