#!/bin/bash

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

# Replace gum choose with select menu
echo "Select files to stage (enter numbers separated by spaces, press Enter when done):"
mapfile -t files_array <<< "$unstaged_files"
select file in "${files_array[@]}"; do
  if [ -n "$file" ]; then
    selected_files+=("$file")
  else
    break
  fi
done

echo "🪚 Selected files:"
for file in "${selected_files[@]}"; do
  echo "Diff for $file:"
  show_diff "$file" | less -R
done

if [ ${#selected_files[@]} -eq 0 ]; then
  echo "No files selected for staging."
  exit 0
fi

# Replace gum confirm with read
read -p "Do you want to stage these files? (y/N) " response
if [[ "$response" =~ ^[Yy]$ ]]; then
  printf "%s\n" "${selected_files[@]}" | xargs git add
  echo "Selected files have been staged."
else
  echo "No files were staged."
fi
