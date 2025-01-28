#!/bin/bash

# Stage changes and capture the output
stage_output=$(git-stage)

# Check if there are no unstaged files
if [[ "$stage_output" == "No unstaged files found." ]]; then
  echo "$stage_output"
  exit 0
fi

echo "$stage_output"

# Replace gum confirm with read
read -p "Do you want to commit these changes? (y/N) " response
if [[ "$response" =~ ^[Yy]$ ]]; then
  git-commit
  echo "Changes have been added."
else
  echo "Changes were not added."
fi
