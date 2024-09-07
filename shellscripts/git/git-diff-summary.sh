#!/bin/bash

git diff --staged | fabric --pattern summarize_git_diff >commit_msg.tmp
if [ -s commit_msg.tmp ]; then
  commit_msg=$(cat commit_msg.tmp | gum write --width 80 --height 20)
  if gum confirm "Commit with message: $commit_msg"; then
    git commit -m "$commit_msg"
  else
    echo "Commit aborted."
  fi
  rm commit_msg.tmp
else
  echo "No changes to commit."
fi
