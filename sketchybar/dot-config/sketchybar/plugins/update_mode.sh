#!/bin/bash

if [ "$SENDER" = "skhd_mode_change" ]; then
	sketchybar --set "$NAME" label="$INFO"
fi
