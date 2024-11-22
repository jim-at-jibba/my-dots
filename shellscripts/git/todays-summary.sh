#!/bin/zsh

# Function to show usage
show_usage() {
  cat <<EOF
Usage: $0 [repository-path]

Analyzes your git commits from all branches and generates a detailed summary for LLM processing.
Shows commits made by the current git user.
If no repository path is provided, shows a selection menu of available git repositories.

Example:
    $0 ~/projects/my-repo
    $0 ../another-repo
    $0 .    (for current directory)
    $0      (shows selection menu)
EOF
  exit 1
}

# Function to find git repositories
find_git_repos() {
  local search_dirs=("$HOME/projects" "$HOME/repos" "$HOME/code" "$HOME/dev" ".")
  local repos=""

  for dir in "${search_dirs[@]}"; do
    if [[ -d "$dir" ]]; then
      fd -H -t d '^\.git$' "$dir" -x echo {//} 2>/dev/null
    fi
  done
}

# Function to validate git repository
validate_repo() {
  local repo_path="$1"

  if [[ ! -d "$repo_path" ]]; then
    echo "Error: Directory '$repo_path' does not exist." >&2
    exit 1
  fi

  if ! git -C "$repo_path" rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: '$repo_path' is not a git repository." >&2
    exit 1
  fi
}

# Check for gum installation
if ! command -v gum &>/dev/null; then
  echo "Error: 'gum' is not installed. Please install it first:"
  echo "brew install gum    # for macOS"
  echo "apt install gum     # for Ubuntu/Debian"
  exit 1
fi

# Handle repository selection
if [[ $# -eq 0 ]]; then
  echo "Searching for git repositories..."
  REPO_PATH=$(find_git_repos | sort -u | gum filter --header "Select a repository:")

  if [[ -z "$REPO_PATH" ]]; then
    echo "No repository selected."
    exit 1
  fi
else
  REPO_PATH="$1"
fi

# Get absolute path and validate repository
REPO_PATH=$(cd "$REPO_PATH" 2>/dev/null && pwd)
validate_repo "$REPO_PATH"
cd "$REPO_PATH" || exit 1

# Get current user's email from git config
GIT_USER_EMAIL=$(git config user.email)
if [[ -z "$GIT_USER_EMAIL" ]]; then
  echo "Error: Unable to get git user email. Please configure git user.email" >&2
  exit 1
fi

# Select date range
DATE_RANGE=$(gum choose --header "Select commit date range:" "Today's commits" "Yesterday's commits")
TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -v-1d +%Y-%m-%d)

case "$DATE_RANGE" in
"Today's commits")
  START_DATE="$TODAY"
  END_DATE="$TODAY"
  ;;
"Yesterday's commits")
  START_DATE="$YESTERDAY"
  END_DATE="$YESTERDAY"
  ;;
esac

# Create temp file and write header
TEMP_FILE=$(mktemp)
cat <<EOF >"$TEMP_FILE"
Git Repository Changes Analysis - Your Commits Across All Branches
Repository: $REPO_PATH
Git User: $GIT_USER_EMAIL
Analysis Date: $TODAY
Analyzing commits for: $DATE_RANGE
----------------------------------------
EOF

# Get commits for selected date range
git log --all --author="$GIT_USER_EMAIL" \
  --since="$START_DATE 00:00:00" --until="$END_DATE 23:59:59" \
  --pretty=format:"Commit: %h%nAuthor: %an%nDate: %ad%nBranch: %D%nMessage: %s%n" \
  --patch | while IFS= read -r line; do
  echo "$line" >>"$TEMP_FILE"
done

# Add contribution statistics
echo -e "\nYour Contribution Statistics:" >>"$TEMP_FILE"
echo "Total commits: $(git log --all --author="$GIT_USER_EMAIL" --since="$START_DATE 00:00:00" --until="$END_DATE 23:59:59" --oneline | wc -l | tr -d ' ')" >>"$TEMP_FILE"
echo "Files changed: $(git log --all --author="$GIT_USER_EMAIL" --since="$START_DATE 00:00:00" --until="$END_DATE 23:59:59" --name-only --pretty=format:"" | sort -u | wc -l | tr -d ' ')" >>"$TEMP_FILE"
echo "Branches with activity: $(git branch -a --contains $(git log --all --author="$GIT_USER_EMAIL" --since="$START_DATE 00:00:00" --format="%H" | head -n 1) | wc -l | tr -d ' ')" >>"$TEMP_FILE"

# Get repo name and add prompt
REPO_NAME=$(basename "$REPO_PATH")

cat <<EOF >>"$TEMP_FILE"

Prompt for LLM analysis:
Please analyze the above git repository changes and provide a detailed summary in the exact format below:

# Summary of Changes - $REPO_NAME
- **Feature Addition**: [What was added or enhanced]
- **Bug Fix**: [What issues were resolved]
- **Code Refactoring**: [What code improvements were made]
- **Impact**: [How changes affect the codebase and user experience]
- **Technical Debt**: [What complexities or future improvements were introduced]

Keep your response concise and focused on code changes rather than commit messages.
Each bullet point should be brief but specific, highlighting the technical details of the changes.
Use technical language when describing the changes but keep it clear and understandable.
Identify concrete examples from the code when possible.

For example:
# Summary of Changes - session-manager
- **Feature Addition**: Added \`isFinishedSession\` prop for enhanced session state management.
- **Bug Fix**: Implemented check to prevent actions on finished sessions.
- **Code Refactoring**: Modularized session versioning and improved async session saving.
- **Impact**: Improved session control, reduced data loss, refined user experience.
- **Technical Debt**: Introduced async complexity; potential error handling improvements needed.
EOF

# Output and cleanup
response=$(cat "$TEMP_FILE" | fabric -m "$model" -cp ai)
gum pager <<<"$response"
rm "$TEMP_FILE"
