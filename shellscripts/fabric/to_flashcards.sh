#!/bin/bash

# Set up trap to handle SIGINT (Ctrl+C)
trap 'exit 130' SIGINT
# Source the get_model function
source_file="/Users/jamesbest/dotfiles/shellscripts/get_model.sh"

if [ -f "$source_file" ]; then
  source "$source_file"
else
  echo "Error: $source_file not found" >&2
  exit 1
fi

# Check if the function is available
if ! command -v get_model &>/dev/null; then
  echo "Error: get_model function not found" >&2
  exit 1
fi

# Use the get_model function
model=$(get_model)
echo "current model :: $model"

input_text_path=$(gum file ~/MyBrain/MyBrain)

echo "Chosen path: $input_text_path"
if gum confirm "Do you want to create flash cards from this content?"; then
  output_dir="$HOME/Documents/generated-mochi"
  output_file="$output_dir/$(basename "$input_text_path")"
  cat "$input_text_path" | fabric -m "$model" --pattern to_mochi >"$output_file"
  echo "🪚 Generated file: $output_file" >&2
else
  echo "Operation cancelled."
fi
