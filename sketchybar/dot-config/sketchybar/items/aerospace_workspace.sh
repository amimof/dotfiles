#!/bin/bash
sketchybar --add event aerospace_workspace_change

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
for sid in $(aerospace list-workspaces --all); do
  icon="$(($sid + -1))"

  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    icon="${SPACE_ICONS[icon]}" \
    icon.padding_left=7 \
    icon.padding_right=7 \
    background.color=0x40ffffff \
    background.corner_radius=5 \
    background.height=25 \
    label.drawing=off \
    click_script="aerospace workspace $sid" \
    script="$CONFIG_DIR/plugins/aerospace.sh $sid" # label="$sid" \
done
