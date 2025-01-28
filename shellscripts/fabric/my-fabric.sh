#!/bin/bash

# Array of commands with labels
commands=(
  "Question AI:question_ai"
  "Format Geekbot: format_geekbot"
  "Format Limitless: format_limitless"
  "Weekly menu: weekly_dinner_generator"
  "Rate Youtube:fytr"
  "Summarise Youtube:fyts"
  "To Motchi:to_flashcards"
  "Format Granola:format_granola"
)

echo

cat <<"EOF"
          _          _                   _
         /\ \       / /\                / /\
        /  \ \     / /  \              / /  \
       / /\ \ \   / / /\ \            / / /\ \
      / / /\ \_\ / / /\ \ \          / / /\ \ \
     / /_/_ \/_// / /  \ \ \        / / /\ \_\ \
    / /____/\  / / /___/ /\ \      / / /\ \ \___\
   / /\____\/ / / /_____/ /\ \    / / /  \ \ \__/
  / / /      / /_________/\ \ \  / / /____\_\ \
 / / /      / / /_       __\ \_\/ / /__________\
 \/_/       \_\___\     /____/_/\/_____________/

 FABRIC AI
EOF

echo
# Extract labels for display
labels=()
for item in "${commands[@]}"; do
  labels+=("${item%%:*}")
done

# Replace gum choose with simple select menu
PS3="Select an option: "
select label in "${labels[@]}"; do
    if [ -n "$label" ]; then
        selected_label="$label"
        break
    fi
done

# Find the corresponding command for the selected label
if [ -n "$selected_label" ]; then
  for item in "${commands[@]}"; do
    if [[ "$item" == "$selected_label:"* ]]; then
      selected_command="${item#*:}"
      break
    fi
  done

  # Execute the selected command
  if [ -n "$selected_command" ]; then
    eval "$selected_command"
  else
    echo "Error: Command not found for selected label."
  fi
else
  echo "No command selected."
fi
