#!/bin/bash

# Set up trap to handle SIGINT (Ctrl+C)
trap 'exit 130' SIGINT

# Function to generate header with metadata
generate_header() {
  local url="$1"
  local title="$2"
  local d=$(date +"%Y-%m-%d")

  echo "---"
  echo "title: \"$title\""
  echo "url: $url"
  echo "date: $d"
  echo "type: video_summary"
  echo "tags:"
  echo "  - 🪴weedy"
  echo "  - 🤖generated"
  echo "source:" "$url"
  echo "---"
  echo
  echo "# $title"
  echo
  echo "## Summary"
  echo
}

# Get the video URL from user input
video_url=$(gum input --placeholder "Video URL...")
dest="$HOME/MyBrain/MyBrain/00_Fleeting"
# Display the entered URL and ask for confirmation
echo "Entered URL: $video_url"
if gum confirm "Do you want to extract wisdom from this video?"; then

  title=$(yt-dlp --get-title "$video_url")
  sanitized_title=$(echo "$title" | tr -cd '[:alnum:][:space:]' | tr '[:space:]' '_')
  output_file="$dest/${sanitized_title}.md"

  # Generate header and write to file
  generate_header "$video_url" "$title" >"$output_file"

  yt "$video_url" | fabric --pattern extract_wisdom >>"$output_file"
  echo "Wisdom extracted and saved to: $output_file"
else
  echo "Operation cancelled."
fi
