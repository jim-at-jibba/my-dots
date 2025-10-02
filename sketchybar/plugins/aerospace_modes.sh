#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
CURRENT_MODE="$(aerospace list-modes --current)"

if [ "$CURRENT_MODE" = 'main' ]; then
    DRAWING=off
    ICON_COLOR="$BLUE"
else
    DRAWING=on
    ICON_COLOR="$MAGENTA"
fi

sketchybar --set "$NAME" \
    label="$CURRENT_MODE" \
    icon.color="$ICON_COLOR" \
    drawing="$DRAWING"
