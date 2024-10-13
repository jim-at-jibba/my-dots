#!/bin/bash

# Let user choose the week
week_choice=$(gum choose "Current Week" "Next Week")

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

# Generate the menu
menu=$(gum spin --spinner points --title "Generating menu" --show-output -- fabric -p weekly-dinner-generator)

# Display the menu
gum pager <<<"$menu"

# Ask for confirmation
if gum confirm "Do you want to save this meal plan?"; then
  write_to_file "$file_path" "$menu"
else
  echo "Menu was not saved."
fi
