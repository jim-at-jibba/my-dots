#!/bin/bash

# Check if gum is installed
if ! command -v gum &>/dev/null; then
  echo "gum is not installed. Please install it first."
  exit 1
fi

# Check if current directory is a git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Not a git repository. Please run this script in a git repository."
  exit 1
fi

# Get list of unstaged files
unstaged_files=$(git ls-files --modified --others --exclude-standard)
if [ -z "$unstaged_files" ]; then
  echo "No unstaged files found."
  exit 0
fi

# Function to show diff
show_diff() {
  local file=$1
  if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
    git diff --color=always "$file"
  else
    echo "New file: $file"
    cat "$file"
  fi
}

# Use gum to select files for staging and show diff
selected_files=$(echo "$unstaged_files" | gum choose --no-limit --height 15 --cursor.foreground="#FF0" --selected.foreground="#0FF" | tee /dev/tty)

echo "🪚 Selected files:"
echo "$selected_files" | while read -r file; do
  echo "Diff for $file:"
  show_diff "$file" | less -R
done

if [ -z "$selected_files" ]; then
  echo "No files selected for staging."
  exit 0
fi

# Confirm staging
if gum confirm "Do you want to stage these files?"; then
  echo "$selected_files" | xargs git add
  echo "Selected files have been staged."
else
  echo "No files were staged."
fi
