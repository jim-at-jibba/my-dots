#!/bin/bash
# Usage: ./create-pr.sh
# Usage: git-create-pr

# Get the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Get the base branch using gum input with default value "staging"
base_branch=$(gum input --placeholder "Enter base branch (default: staging)" --value "staging")

# Extract the changes
changes=$(git log --no-merges "$base_branch".."$current_branch" | fabric --pattern summarize_git_changes | awk '/## CHANGES/ {flag=1; next} flag')

# Get the PR title using gum input
pr_title=$(gum input --placeholder "Enter PR title")

# Create the pull request using the extracted changes and user-provided title
gh pr create --body "$changes" --title "$pr_title" --base "$base_branch" --head "$current_branch" --draft
