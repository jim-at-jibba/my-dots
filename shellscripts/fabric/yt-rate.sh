#!/bin/bash

# Set up trap to handle SIGINT (Ctrl+C)
trap 'exit 130' SIGINT

# Get the video URL from user input
video_url=$(gum input --placeholder "Video URL...")

# Display the entered URL and ask for confirmation
echo "Entered URL: $video_url"
if gum confirm "Do you want to rate this video?"; then
  yt "$video_url" | fabric --pattern rate_content
else
  echo "Operation cancelled."
fi
