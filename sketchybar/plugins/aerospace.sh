#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors
focus_sid=$(aerospace list-workspaces --focused)

if [ "$1" = "$focus_sid" ]; then
  sketchybar --set $NAME background.drawing=on \
    background.color=$ACCENT_COLOR \
    label.color=$BAR_COLOR \
    icon.color=$BAR_COLOR
else
  sketchybar --set $NAME background.drawing=off \
    label.color=$ACCENT_COLOR \
    icon.color=$ACCENT_COLOR
fi
