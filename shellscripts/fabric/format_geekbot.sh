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
# Replace gum choose with simple select menu
PS3="Select name: "
options=("me" "ben" "dav" "myles")
select name in "${options[@]}"; do
    if [ -n "$name" ]; then
        break
    fi
done

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
formatted_text=$(echo "$text" | fabric -m "$model" -p format_geekbot)

escaped_text=$(printf '%s\n' "$formatted_text" | sed 's/[\/&]/\\&/g')

# Use perl to replace [name] with the formatted text
perl -i -p0e "s/\[$name\]/$escaped_text/s" "$file_path"

if [ $? -eq 0 ]; then
  echo "Text has been inserted into $file_path"
else
  echo "An error occurred while inserting the text."
fi
