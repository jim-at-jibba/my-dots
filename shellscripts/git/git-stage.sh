#!/bin/bash

# Usage: git-stage.sh
# Usage: gsf

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

# Use gum to select files for staging
selected_files=$(echo "$unstaged_files" | gum choose --no-limit)

if [ -z "$selected_files" ]; then
  echo "No files selected for staging."
  exit 0
fi

# Stage selected files
echo "$selected_files" | xargs git add

git status

echo "Selected files have been staged."
