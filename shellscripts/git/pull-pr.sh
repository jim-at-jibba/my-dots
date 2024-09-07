#/bin/bash
# Usage: ./pull-pr.sh
# Usage: gppr

gh pr list --json number,title,author --jq '.[] | "\(.number) \(.title) by \(.author.login)"' | cut -f1,2,3 | gum choose | cut -d' ' -f1 | xargs gh pr checkout
