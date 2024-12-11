#!/bin/bash
LABELS=("" "󰚩" "󰙏" "" "" "" "" "󰓇" "󰡷")
INDEX=0

for sid in $(aerospace list-workspaces --all); do
  label="${LABELS[$INDEX]}"

  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.corner_radius=1 \
    background.height=48 \
    background.drawing=off \
    icon.padding_left=0 \
    icon.padding_right=0 \
    label.padding_left=10 \
    label.padding_right=10 \
    label.font="FiraMono Nerd Font:Bold:18.0" \
    label="$label" \
    update_freq=1 \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/aerospace.sh $sid"

  INDEX=$((INDEX + 1))
done

# Handle workspace changes
sketchybar --add event aerospace_workspace_change
