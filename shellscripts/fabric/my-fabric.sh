#!/bin/bash

# Array of commands with labels
commands=(
  "Question AI:question_ai"
  "Format Geekbot: format_geekbot"
  "Weekly menu: weekly_dinner_generator"
  "Rate Youtube:fytr"
  "Summarise Youtube:fyts"
  "To Flashcards:to_flashcards"
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

# Use gum choose to select a command by label
selected_label=$(gum choose "${labels[@]}")

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
