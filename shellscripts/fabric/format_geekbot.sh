#!/bin/bash

# Select name using gum choose
name=$(gum choose "me" "ben" "dav" "myles")

# Get current date
current_date=$(date +"%Y-%m-%d")
current_year=$(date +"%Y")
current_month=$(date +"%B")

# Construct the file path
file_path="/Users/jamesbest/MyBrain/MyBrain/07_Dev Journal/$current_year/$current_month/$current_date.md"

# Check if the file exists
if [ ! -f "$file_path" ]; then
  echo "File not found: $file_path"
  exit 1
fi

# Get text input from user
text=$(pbpaste | gum write --width 80 --height 20)

# Format the text using fabric
formatted_text=$(echo "$text" | fabric -p format_geekbot)

# Use perl to replace [name] with the formatted text
perl -i -p0e "s/\[$name\]/$formatted_text/s" "$file_path"

if [ $? -eq 0 ]; then
  echo "Text has been inserted into $file_path"
else
  echo "An error occurred while inserting the text."
fi
