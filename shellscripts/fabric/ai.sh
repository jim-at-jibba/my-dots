#!/bin/bash
query=$(gum write --width 80 --height 20)

echo "Query: $query"
echo "$query" | fabric -sp ai
