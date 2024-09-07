#!/bin/bash

# Stage changes and capture the output
stage_output=$(git-stage)

# Check if there are no unstaged files
if [[ "$stage_output" == "No unstaged files found." ]]; then
  echo "$stage_output"
  exit 0
fi

echo "$stage_output"

# Ask for confirmation using gum confirm
<<<<<<< HEAD
<<<<<<< HEAD
if gum confirm "Do you want to commit these changes?"; then
  # If confirmed, add the changes
  git-commit
=======
if gum confirm "Do you want to commit these changes?"; then
  # If confirmed, edit the commit message and commit
  commit_msg=$(cat commit_msg.tmp | gum write --width 80 --height 20)
  git commit -m "$commit_msg"
  echo "Changes have been committed."
>>>>>>> Snippet
  echo "Changes have been added."
=======
if gum confirm "Do you want to commit these changes?"; then
  # If confirmed, edit the commit message and commit
  commit_msg=$(cat commit_msg.tmp | gum write --width 80 --height 20)
  git commit -m "$commit_msg"
  echo "Changes have been committed."
>>>>>>> Snippet
else
  echo "Changes were not added."
fi
