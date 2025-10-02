#!/bin/bash

# echo "$1, $FOCUSED_WORKSPACE" > /tmp/logs.txt

source "$CONFIG_DIR/colors.sh"

ws_clients_number="$(aerospace list-windows --workspace "$1" 2>/dev/null | wc -l | awk '{print $1}')"

# echo "ws: $1" > /tmp/logs.txt

if [ "$1" = "$FOCUSED_WORKSPACE" ] || [ "$1" = "$(aerospace list-workspaces --focused)" ]; then
    # Active ws
    sketchybar --set "$NAME" \
        icon.color="$BAR_COLOR" \
        label.color="$BAR_COLOR" \
        background.drawing=on \
        background.color="$ACCENT_COLOR" \
        background.height=25 \
        background.y_offset=0 \
        drawing=on
elif [ "$ws_clients_number" -gt 0 ] && [ "$(aerospace list-workspaces --monitor 2)" = "$1" ] && [ "$1" != "$FOCUSED_WORKSPACE" ]; then
    # Not active second monitor ws with clients
    sketchybar --set "$NAME" \
        icon.color="$BAR_COLOR" \
        label.color="$BAR_COLOR" \
        background.drawing=on \
        background.color="$ACCENT_COLOR" \
        background.height=3 \
        background.y_offset=-10 \
        drawing=on
elif [ "$ws_clients_number" -gt 0 ] && [ "$1" != "$FOCUSED_WORKSPACE" ]; then
    # Not active ws with clients
    sketchybar --set "$NAME" \
        icon.color="$BAR_COLOR" \
        label.color="$BAR_COLOR" \
        background.drawing=on \
        background.color="$ACCENT_COLOR" \
        background.height=3 \
        background.y_offset=-10 \
        drawing=on
else
    # Default
    sketchybar --set "$NAME" \
        icon.color="$BAR_COLOR" \
        label.color="$BAR_COLOR" \
        background.drawing=off \
        drawing=off
fi
# focus_sid=$(aerospace list-workspaces --focused)
#
# if [ "$1" = "$focus_sid" ]; then
#   sketchybar --set $NAME background.drawing=on \
#     background.color=$ACCENT_COLOR \
#     label.color=$BAR_COLOR \
#     icon.color=$BAR_COLOR
# else
#   sketchybar --set $NAME background.drawing=off \
#     label.color=$ACCENT_COLOR \
#     icon.color=$ACCENT_COLOR
# fi
