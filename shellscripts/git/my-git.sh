#!/bin/bash

# Array of commands with labels
commands=(
  "Commit changes:git-commit"
  "Stage files:git-stage"
  "Pull PR:git-pull-pr"
  "Create PR:git-create-pr"
  "Stage and commit:git-stage-commit"
  "Todays summary:todays-summary"
)

# Print a blank line
echo

cat <<"EOF"
/$$$$$$$$$/$$$$$$$/$$$$$$$$$   o--o--o
|__  $$__/|_  $$_/|__  $$__/   |     \
   | $$     | $$     | $$      o--o   o
   | $$     | $$     | $$      |   \
   | $$     | $$     | $$      o    o
   | $$     | $$     | $$      |     \
   | $$    /$$$$$$   | $$      o--o--o
   |__/   |______/   |__/      Git tool
EOF

# Print a blank line
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
