#!/bin/bash
declare -A ws_icons_size
ws_icons_size["1"]="18.5"
ws_icons_size["2"]="19.0"
ws_icons_size["3"]="17.0"
ws_icons_size["4"]="19.0"
ws_icons_size["5"]="18.0"
ws_icons_size["6"]="21.0"
ws_icons_size["7"]="18.0"
ws_icons_size["8"]="18.0"
ws_icons_size["9"]="18.0"

for sid in $(aerospace list-workspaces --all); do
    if [ "$sid" = 'NSP' ]; then
        continue
    fi

    ws_icon="${WS_ICONS[$sid]}"
    ws_icon_size="${ws_icons_size[$sid]}"

    # trigger only new and prev ws helps to sketchybar ws item works much faster, as we reloading only 2 sub-items, instead all ws items
    sketchybar --add event aerospace_workspace_change_"$sid"
    sketchybar --add item space."$sid" left \
        --subscribe space."$sid" aerospace_workspace_change_"$sid" \
        --set space."$sid" \
        background.color="$WS_DEFAULT_BG_COLOR" \
        background.corner_radius=1 \
        background.height=25 \
        background.drawing=off \
        icon.padding_left=10 \
        icon.padding_right=2 \
        label.padding_left=5 \
        label.padding_right=8 \
        padding_left=0 \
        padding_right=2 \
	label="$sid" \
        icon="$ws_icon" \
        icon.font.size="$ws_icon_size" \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospace.sh $sid"
done
