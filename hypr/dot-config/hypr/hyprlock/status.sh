#!/usr/bin/env bash

############ Variables ############
enable_battery=true
battery_charging=false

####### Check availability ########
for battery in /sys/class/power_supply/*-battery; do
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
		echo "  "
	elif (( charge >= 70)); then
		echo "  "
	elif (( charge >= 50)); then
		echo "  "
	elif (( charge >= 10)); then
		echo "  "
	elif (( charge >= 1)); then
		echo "  "
	else
		echo " "
	fi
}


network_icon() {
	# Check for ethernet (en*, eth*)
	for iface in /sys/class/net/en* /sys/class/net/eth*; do
		if [[ -f "$iface/operstate" ]] && [[ $(cat "$iface/operstate") == "up" ]]; then
			echo "󰈀 "
			return
		fi
	done
	# Check for wifi (wl*)
	for iface in /sys/class/net/wl*; do
		if [[ -f "$iface/operstate" ]] && [[ $(cat "$iface/operstate") == "up" ]]; then
			echo -e "󰖩 "
			return
		fi
	done
	# No connection
	echo "󰖪 "
}

############# Output #############
if [[ $enable_battery == true ]]; then
  if [[ $battery_charging == true ]]; then
    echo -n "󰚥 "
  fi
	charge=$(cat /sys/class/power_supply/*-battery/capacity | head -1)
	icon=$(battery_icon $charge)
	echo -n "$icon $charge%"
fi

echo -n "  ·  $(network_icon)"

echo ''
