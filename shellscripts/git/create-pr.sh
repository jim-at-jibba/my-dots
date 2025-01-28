#!/bin/bash
# Usage: ./create-pr.sh
# Usage: git-create-pr

# Get the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Replace gum input with read
read -p "Enter base branch (default: staging): " base_branch
base_branch=${base_branch:-staging}

# Extract the changes
# changes=$(git log --no-merges "$base_branch".."$current_branch" | fabric --pattern summarize_git_changes | awk '/## CHANGES/ {flag=1; next} flag')
changes=$(git log --no-merges "$base_branch".."$current_branch" | fabric --pattern summarize_git_changes)

# Replace gum write with cat
echo "Enter PR message (press Ctrl+D when done):"
pr_message=$(cat)

# Replace gum input with read
read -p "Enter PR title: " pr_title

# Create the pull request using the extracted changes and user-provided title
gh pr create --body "$pr_message" --title "$pr_title" --base "$base_branch" --head "$current_branch" --draft
