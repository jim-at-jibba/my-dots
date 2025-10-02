CURRENT_MODE="$(aerospace list-modes --current)"

keymode=(
    background.padding_right=2
    icon="$KEYBOARD"
    icon.y_offset=2.5
    label="$CURRENT_MODE"
    label.font.style="Bold Italic"
    update_freq=0
    icon.color="$ACCENT_COLOR"
    label.color="$ACCENT_COLOR"
    script="$PLUGIN_DIR/aerospace_modes.sh"
    drawing="off"
)

sketchybar --add event keymode_update \
    --add item keymode right \
    --set keymode "${keymode[@]}" \
    --subscribe keymode keymode_update
