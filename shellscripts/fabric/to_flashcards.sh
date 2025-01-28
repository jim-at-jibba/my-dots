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

# Replace gum file selection with fzf
input_text_path=$(find ~/MyBrain/MyBrain -type f | fzf --height 40% --reverse --prompt="Select file: ")

# Exit if no file was selected (user pressed esc)
if [ -z "$input_text_path" ]; then
    echo "No file selected. Exiting."
    exit 1
fi

echo "Chosen path: $input_text_path"

# Replace gum confirm with a simple yes/no prompt
read -p "Do you want to create flash cards from this content? (y/N) " response
if [[ "$response" =~ ^[Yy]$ ]]; then
  output_dir="$HOME/Documents/generated-mochi"
  output_file="$output_dir/$(basename "$input_text_path")"
  # Create a temporary file
  temp_file=$(mktemp)

  # Generate content to temp file
  cat "$input_text_path" | fabric -m "$model" --pattern to_mochi >"$temp_file"

  # Open in vim for editing
  NVIM_APPNAME=lazy nvim "$temp_file"

  # Move edited content to final destination
  mv "$temp_file" "$output_file"

  echo "🪚 Generated file: $output_file" >&2
else
  echo "Operation cancelled."
fi
