#!/bin/bash

# Check if the project is clean (no staged or unstaged changes)
if git diff --quiet HEAD && git diff --staged --quiet; then
  echo "The project is clean. No changes to commit."
  exit 0
fi

if git diff --staged --quiet; then
  echo "No changes staged for commit."
  read -p "There are unstaged changes. Do you want to stage some? (y/N) " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    git add -p
    exec "$0" "$@" # Recall the script
  fi
fi

echo "Generating commit message..."
if ! git diff --staged | claude --model sonnet -p "Summarize the changes in this git diff following conventional commit strategy. I ONLY want the commit message with no explanation." --output-format text >commit_msg.tmp 2>/dev/null; then
  echo "Error: Failed to generate commit message. Please check if claude is installed and accessible."
  exit 1
fi 

if [ -s commit_msg.tmp ]; then
  echo "Enter/edit commit message (press Ctrl+D when done):"
  commit_msg=$(cat commit_msg.tmp | cat)
  read -p "Commit with message: $commit_msg (y/N) " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    git commit -m "$commit_msg"
  else
    echo "Commit aborted."
  fi
  rm commit_msg.tmp
else
  echo "No changes to commit."
fi
