#!/bin/bash

# Set up trap to handle SIGINT (Ctrl+C)
trap 'exit 130' SIGINT

# Replace gum input with read
read -p "Video URL: " video_url

# Replace gum confirm with simple yes/no prompt
read -p "Do you want to rate this video? (y/N) " response
if [[ "$response" =~ ^[Yy]$ ]]; then
    yt "$video_url" | fabric --pattern rate_content
else
    echo "Operation cancelled."
fi
