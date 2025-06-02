#!/bin/zsh

# To get a high-level summary of your work:
# 1. Run this script: summarize-commits.sh "1 week ago"
# 2. Copy the output (which includes categorized commits by type)
# 3. Use with the following prompt:
#
# 📋 Weekly Dev Summary
#
# ```
# [paste script output here]
# ```
#
# Show:
# • Features added (when)
# • Improvements made
# • Key fixes
# • Stats
#
# The AI will provide a structured summary of your development work organized by major themes and timing.
# The script automatically categorizes commits into: New Features, Improvements & Refactoring,
# Bug Fixes, Updates, and Cleanup.

# Function to extract the main topic from a commit message
get_commit_topic() {
    local msg="$1"
    # Convert message to lowercase for better matching
    msg=$(echo "$msg" | tr '[:upper:]' '[:lower:]')
    
    # Check for bug fixes first
    if echo "$msg" | grep -q "fix\|issue\|bug\|error\|crash"; then
        echo "Bug Fixes"
    # Check for new features
    elif echo "$msg" | grep -q "add\|implement\|create\|initialize\|new"; then
        echo "New Features"
    # Check for improvements and refactoring
    elif echo "$msg" | grep -q "refactor\|enhance\|improve\|optimize\|clean"; then
        echo "Improvements & Refactoring"
    # Check for updates
    elif echo "$msg" | grep -q "update\|upgrade\|bump\|version"; then
        echo "Updates"
    # Check for cleanup
    elif echo "$msg" | grep -q "remove\|delete\|deprecate\|clean"; then
        echo "Cleanup"
    else
        echo "Other Changes"
    fi
}

# Get timeframe from argument or default to 1 week
timeframe="${1:-1 week ago}"

# Print header
echo "Summary of changes since $timeframe:"
echo "===================================\n"

# Get all commits in reverse chronological order
commits=$(git --no-pager log --since="$timeframe" --pretty=format:"%h - %s (%cr) <%an>")

# Create temporary files for categorized commits
tmp_dir=$(mktemp -d)
new_features="$tmp_dir/new_features"
improvements="$tmp_dir/improvements"
bug_fixes="$tmp_dir/bug_fixes"
updates="$tmp_dir/updates"
cleanup="$tmp_dir/cleanup"
other="$tmp_dir/other"

# Categorize commits
echo "$commits" | while IFS= read -r commit; do
    # Extract just the commit message, removing hash and timestamp
    msg=$(echo "$commit" | sed 's/^[a-f0-9]\+ - \(.*\) ([0-9].*ago) <.*>/\1/')
    topic=$(get_commit_topic "$msg")
    case "$topic" in
        "New Features")
            echo "$commit" >> "$new_features"
            ;;
        "Improvements & Refactoring")
            echo "$commit" >> "$improvements"
            ;;
        "Bug Fixes")
            echo "$commit" >> "$bug_fixes"
            ;;
        "Updates")
            echo "$commit" >> "$updates"
            ;;
        "Cleanup")
            echo "$commit" >> "$cleanup"
            ;;
        *)
            echo "$commit" >> "$other"
            ;;
    esac
done

# Function to print section if it exists and has content
print_section() {
    local file="$1"
    local title="$2"
    if [[ -f "$file" && -s "$file" ]]; then
        echo "\n$title:"
        echo "----------------------------------------"
        cat "$file"
        echo ""
    fi
}

# Print organized summary
echo "Key Developments:\n"

print_section "$new_features" "New Features"
print_section "$improvements" "Improvements & Refactoring"
print_section "$bug_fixes" "Bug Fixes"
print_section "$updates" "Updates"
print_section "$cleanup" "Cleanup"
print_section "$other" "Other Changes"

# Print recent changes
echo "\nMost Recent Changes (last 24 hours):"
echo "----------------------------------------"
git --no-pager log --since="24 hours ago" --pretty=format:"%h - %s (%cr) <%an>"

# Cleanup
rm -rf "$tmp_dir"

# Print total commits
total=$(echo "$commits" | wc -l)
echo "\nTotal commits: $total"

