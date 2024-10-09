#!/bin/bash

query=$(gum input --cursor.foreground "#FF0" \
  --prompt.foreground "#0FF" \
  --placeholder "What do you wanna know?" \
  --prompt "* " \
  --width 80)

echo "Query: $query"
echo "$query" | fabric -sp ai
