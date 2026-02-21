SSID=$(ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / {print $2}')
SSID=$(system_profiler SPAirPortDataType | awk '/Current Network/ {getline;$1=$1; gsub(":",""); print;exit}')

sketchybar --set $NAME \
  icon= icon.color=0xFFFEFEFE \
  label="$SSID"

# sketchybar --set $NAME background.drawing=on \
#   background.color=$ACCENT_COLOR \
#   label.color=$BAR_COLOR \
#   icon.color=$BAR_COLOR \
#   label="$WIFI_SSID_CHANGED"
