#!/bin/bash

git diff | fabric --pattern summarize_git_diff >commit_msg.tmp
if [ -s commit_msg.tmp ]; then
  commit_msg=$(cat commit_msg.tmp)
  gum confirm "Commit with message: $commit_msg" && git add . && git commit -F commit_msg.tmp
  rm commit_msg.tmp
else
  echo "No changes to commit."
fi
