#!/bin/bash

# Array of commands
commands=(
  "git-commit"
  "git-stage"
  "git-pull-pr"
  "git-create-pr"
  "git-stage-commit"
)

# Use gum choose to select a command
selected_command=$(gum choose "${commands[@]}")

# Execute the selected command
if [ -n "$selected_command" ]; then
  eval "$selected_command"
else
  echo "No command selected."
fi
