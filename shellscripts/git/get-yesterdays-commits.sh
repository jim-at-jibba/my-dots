#!/bin/zsh

# This script Git commits made yesterday for a given repository path

# Check if a repository path is provided
if [ $# -eq 1 ]; then
  repo_path="$1"
else
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
  repo_path="."
fi

# Get yesterday's date in the format YYYY-MM-DD
yesterday=$(date -v-1d +%Y-%m-%d)

# Use Git log to fetch yesterday's commits and format the output
# git -C "$repo_path" log --since="$yesterday 00:00:00" --until="$yesterday 23:59:59" --pretty=format:"%h - %s (%an)" --reverse
# Add a blank line before commits
echo "Commits for $yesterday:"
echo "----------------------------------------"
git --no-pager -C "$repo_path" log --all --since="$yesterday 00:00:00" --until="$yesterday 23:59:59" --pretty=format:"%h - %s (%cr) <%an>" --reverse
echo ""  # Add a blank line
echo "----------------------------------------"
# Update the total commits count to match the same criteria as the log display
echo "Total commits yesterday: $(git -C "$repo_path" log --all --since="$yesterday 00:00:00" --until="$yesterday 23:59:59" --oneline | wc -l | tr -d ' ')"
