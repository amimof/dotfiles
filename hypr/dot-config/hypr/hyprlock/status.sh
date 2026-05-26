#!/usr/bin/env bash

############ Variables ############
enable_battery=true
battery_charging=fale

####### Check availability ########
for battery in /sys/class/power_supply/*BAT*; do
  if [[ -f "$battery/uevent" ]]; then
    enable_battery=true
    if [[ $(cat /sys/class/power_supply/*/status | head -1) == "Charging" ]]; then
      battery_charging=true
    fi
    break
  fi
done

battery_icon() {
	local charge="${1:-0}"
	if (( charge >= 90 )); then
		echo -n "  "
	elif (( charge >= 70)); then
		echo "  "
	elif (( charge >= 50)); then
		echo "  "
	elif (( charge >= 10)); then
		echo "  "
  else 
		echo "  "
	fi
}
############# Output #############
if [[ $enable_battery == true ]]; then
  if [[ $battery_charging == true ]]; then
    echo -n "󰚥 "
  fi
	charge=$(cat /sys/class/power_supply/*/capacity | head -1)
	icon=$(battery_icon $charge)
	echo -n "$icon $charge%"
fi

echo ''
