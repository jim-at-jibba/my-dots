#!/bin/bash
# Usage: ./pull-pr.sh
# Usage: gppr

# Get PR list and pipe to fzf for interactive selection
pr_number=$(gh pr list --json number,title,author --jq '.[] | "\(.number) \(.title) by \(.author.login)"' | \
    fzf --height 40% --reverse | \
    cut -d' ' -f1)

# Checkout the selected PR if one was chosen
if [ -n "$pr_number" ]; then
    gh pr checkout "$pr_number"
fi
