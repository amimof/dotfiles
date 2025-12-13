# SSID=$(ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / {print $2}')
SSID=$(system_profiler SPAirPortDataType | awk '/Current Network/ {getline;$1=$1; gsub(":",""); print;exit}')

sketchybar --set $NAME \
  icon= icon.color=0xFFFEFEFE \
  label="$SSID"
