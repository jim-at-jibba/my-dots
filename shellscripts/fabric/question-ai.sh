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

query=$(gum input --placeholder "What do you wanna know?" \
  --prompt "* " \
  --width 80)
echo "Query: $query"
echo

filename="${query// /_}"
answer=$(echo "$query" | fabric -m "$model" -sp ai)
echo "$answer"
printf "\n"

if gum confirm "Do you want to create flash cards from this content?"; then
  output_dir="$HOME/Documents/generated-mochi"
  output_file="$output_dir/$(basename "$filename")"
  echo "$answer" | fabric -m "$model" -p to_mochi >"$output_file".md
  echo
  echo "🪚 Generated file: $output_file" >&2
else
  echo "Operation cancelled."
fi
