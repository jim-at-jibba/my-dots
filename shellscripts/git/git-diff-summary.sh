#!/bin/bash

# Check if the project is clean (no staged or unstaged changes)
if git diff --quiet HEAD && git diff --staged --quiet; then
  echo "The project is clean. No changes to commit."
  exit 0
fi

if git diff --staged --quiet; then
  echo "No changes staged for commit."
  if gum confirm "There are unstaged changes. Do you want to stage some?"; then
    git add -p
    exec "$0" "$@" # Recall the script
  fi
fi

gum spin --title "Generating commit message" --show-output -- git diff --staged | fabric -sp summarize_git_diff >commit_msg.tmp
if [ -s commit_msg.tmp ]; then
  commit_msg=$(cat commit_msg.tmp | gum write --width 80 --height 30)
  if gum confirm "Commit with message: $commit_msg"; then
    git commit -m "$commit_msg"
  else
    echo "Commit aborted."
  fi
  rm commit_msg.tmp
else
  echo "No changes to commit."
fi
