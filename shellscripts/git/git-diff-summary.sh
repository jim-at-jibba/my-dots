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
# git diff --staged | fabric -m claude-3-7-sonnet-latest  -p summarize_git_diff >commit_msg.tmp
git diff --staged | /Users/jamesbest/.claude/local/claude -p "Summarize the changes in this git diff following conversional commit strategy, I only want the commit message" --output-format text >commit_msg.tmp 

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
