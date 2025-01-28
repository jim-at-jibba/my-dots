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
PS3="Select week: "
options=("Current Week" "Next Week")
select week_choice in "${options[@]}"; do
    if [ -n "$week_choice" ]; then
        break
    fi
done

# Get current date, year, week number, and month
if [ "$week_choice" = "Current Week" ]; then
  current_date=$(date +"%Y-%m-%d")
else
  current_date=$(date -v+7d +"%Y-%m-%d")
fi

current_year=$(date -j -f "%Y-%m-%d" "$current_date" +"%Y")
current_week=$(date -j -f "%Y-%m-%d" "$current_date" +"%V")
current_month=$(date -j -f "%Y-%m-%d" "$current_date" +"%B")

# Construct the file path
file_path="/Users/jamesbest/MyBrain/MyBrain/07_Dev Journal/$current_year/$current_month/W$current_week.md"

# Function to write to file
write_to_file() {
  local file="$1"
  local content="$2"

  if [ -f "$file" ]; then
    perl -i -p0e "s/\[weekly_meal_plan\]/$content/s" "$file"
    echo "Menu has been inserted into $file"
  else
    echo "File not found: $file"
    echo "Menu was not saved to file."
  fi
}

# Replace gum spin with simple message
echo "Generating menu..."
menu=$(fabric -m "$model" -p weekly-dinner-generator)

# Replace gum pager with less
echo "$menu" | less

# Replace gum confirm with simple yes/no prompt
read -p "Do you want to save this meal plan? (y/N) " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    write_to_file "$file_path" "$menu"
else
    echo "Menu was not saved."
fi
