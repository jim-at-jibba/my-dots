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

# Get current date
current_date=$(date +"%Y-%m-%d")
current_year=$(date +"%Y")
current_month=$(date +"%B")

# Construct the file path
file_path="/Users/jamesbest/vault2025/02 Daily/$current_year/$current_month/$current_date.md"

# Check if the file exists
if [ ! -f "$file_path" ]; then
  echo "File not found: $file_path"
  exit 1
fi

# Replace gum input with read
read -p "Enter a title for your text: " title

# Read input until a specific end marker
echo "Enter or paste your text (type 'EOF' on a new line when done):"
text=""
while IFS= read -r line; do
    if [ "$line" = "EOF" ]; then
        break
    fi
    text+="$line"$'\n'
done
text=${text%$'\n'} # Remove trailing newline

# Format the text using fabric
formatted_text=$(echo "$text" | fabric -m "$model" -p format_granola)

# Combine title and text
formatted_text="## $title\n\n$formatted_text"

# Append two newlines and the formatted text to the file
echo -e "\n\n$formatted_text" >>"$file_path"

if [ $? -eq 0 ]; then
  echo "Text has been appended to $file_path"
else
  echo "An error occurred while appending the text."
fi
