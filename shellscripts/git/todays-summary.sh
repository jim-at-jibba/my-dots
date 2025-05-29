#!/bin/zsh

# Function to show usage
show_usage() {
  cat <<EOF
Usage: $0 [options] [repository-path]

Analyzes your git commits from all branches and generates a detailed summary for LLM processing.
Shows commits made by the current git user.

Options:
  -h, --help              Show this help message
  -t, --today             Show today's commits
  -y, --yesterday         Show yesterday's commits
  -r, --repos REPOS...    Specify one or more repository paths (separated by spaces)

If no options are provided, shows interactive selection menus.

Examples:
    $0                                       # Interactive mode
    $0 ~/projects/my-repo                    # Interactive date selection for single repo
    $0 --today ~/projects/my-repo            # Today's commits for single repo
    $0 --yesterday --repos ~/repo1 ~/repo2   # Yesterday's commits for multiple repos
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
    return 1
  fi

  if ! git -C "$repo_path" rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: '$repo_path' is not a git repository." >&2
    return 1
  fi
  
  return 0
}

# Function to process a single repository
process_repository() {
  local repo_path="$1"
  local start_date="$2"
  local end_date="$3"
  local date_range_display="$4"
  
  # Get absolute path and validate repository
  local abs_repo_path=$(cd "$repo_path" 2>/dev/null && pwd)
  if ! validate_repo "$abs_repo_path"; then
    return 1
  fi
  
  # Save current directory
  local original_dir=$(pwd)
  cd "$abs_repo_path" || return 1
  
  # Get current user's email from git config
  local git_user_email=$(git config user.email)
  if [[ -z "$git_user_email" ]]; then
    echo "Error: Unable to get git user email in repository '$abs_repo_path'. Please configure git user.email" >&2
    return 1
  fi
  
  local today=$(date +%Y-%m-%d)
  local repo_name=$(basename "$abs_repo_path")
  
  # Create temp file and write header
  local temp_file=$(mktemp)
  cat <<EOF >"$temp_file"
# Commit Summary - $repo_name
Repository: $abs_repo_path
Date Range: $date_range_display
----------------------------------------
EOF
  
  # Get only commit messages for selected date range (no patches, no detailed info)
  git log --all --author="$git_user_email" \
    --since="$start_date 00:00:00" --until="$end_date 23:59:59" \
    --pretty=format:"%h | %s" >>"$temp_file"
  
  # Add simple prompt for LLM
  cat <<EOF >>"$temp_file"

----------------------------------------
Prompt:
Based on these commit messages, provide a brief summary of the work done in this repository.
Include the main features, bug fixes, or improvements that were made.
EOF
  
  # Output and cleanup
  response=$(cat "$temp_file" | fabric -m "gpt-4.1-mini" -cp ai)
  echo "$response"
  rm "$temp_file"
  
  # Return to original directory
  cd "$original_dir" || return 1
}

# Initialize variables
INTERACTIVE=true
TODAY_DATE=$(date +%Y-%m-%d)
YESTERDAY_DATE=$(date -v-1d +%Y-%m-%d)
START_DATE=""
END_DATE=""
DATE_RANGE_DISPLAY=""
REPOSITORIES=()

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_usage
      ;;
    -t|--today)
      INTERACTIVE=false
      START_DATE="$TODAY_DATE"
      END_DATE="$TODAY_DATE"
      DATE_RANGE_DISPLAY="Today's commits"
      shift
      ;;
    -y|--yesterday)
      INTERACTIVE=false
      START_DATE="$YESTERDAY_DATE"
      END_DATE="$YESTERDAY_DATE"
      DATE_RANGE_DISPLAY="Yesterday's commits"
      shift
      ;;
    -r|--repos)
      INTERACTIVE=false
      shift
      # Collect all repository paths until the next option or end of arguments
      while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
        REPOSITORIES+=("$1")
        shift
      done
      ;;
    -*)
      echo "Unknown option: $1" >&2
      show_usage
      ;;
    *)
      # If a single repository is provided without --repos
      if [[ -z "$REPOSITORIES" && $INTERACTIVE == false ]]; then
        REPOSITORIES=("$1")
      elif [[ $INTERACTIVE == true ]]; then
        REPOSITORIES=("$1")
        # If only repository is provided but not date, keep date selection interactive
      fi
      shift
      ;;
  esac
done

# If interactive mode and no repositories specified, show repository selection
if [[ $INTERACTIVE == true && ${#REPOSITORIES[@]} -eq 0 ]]; then
  echo "Searching for git repositories..."
  REPO_PATH=$(find_git_repos | sort -u | fzf --height 40% --reverse --header="Select a repository")
  
  if [[ -z "$REPO_PATH" ]]; then
    echo "No repository selected."
    exit 1
  fi
  
  REPOSITORIES=("$REPO_PATH")
fi

# If no date range specified, show date range selection
if [[ -z "$START_DATE" ]]; then
  DATE_RANGE=$(printf "Today's commits\nYesterday's commits" | \
    fzf --height 20% --reverse --header="Select commit date range")
  
  if [[ -z "$DATE_RANGE" ]]; then
    echo "No date range selected."
    exit 1
  fi
  
  case "$DATE_RANGE" in
  "Today's commits")
    START_DATE="$TODAY_DATE"
    END_DATE="$TODAY_DATE"
    DATE_RANGE_DISPLAY="$DATE_RANGE"
    ;;
  "Yesterday's commits")
    START_DATE="$YESTERDAY_DATE"
    END_DATE="$YESTERDAY_DATE"
    DATE_RANGE_DISPLAY="$DATE_RANGE"
    ;;
  esac
fi

# Save original directory
ORIGINAL_DIR=$(pwd)

# Process each repository
for repo in "${REPOSITORIES[@]}"; do
  echo "Processing repository: $repo"
  echo "-------------------------------------------"
  process_repository "$repo" "$START_DATE" "$END_DATE" "$DATE_RANGE_DISPLAY"
  
  # Always return to original directory between repositories
  cd "$ORIGINAL_DIR" 2>/dev/null || {
    echo "Error: Could not return to original directory. Exiting."
    exit 1
  }
  
  echo ""
  echo "-------------------------------------------"
  echo ""
done