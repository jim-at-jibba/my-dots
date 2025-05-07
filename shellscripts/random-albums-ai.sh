#!/bin/bash

# AI-Powered Album Recommendation
# This script uses the OpenAI API to recommend albums worth listening to across various genres
# and then uses the Spotify API to look them up and add them to your journal file
#
# Usage:
#   ./script.sh                  - Get recommendation and add to journal
#   ./script.sh -t               - Get recommendation in terminal only
#   ./script.sh --terminal       - Get recommendation in terminal only
#   ./script.sh mark_listened ID - Mark album with ID as listened

# ----- Configuration -----
# Spotify API credentials - Set these as environment variables:
# export SPOTIFY_CLIENT_ID="your_client_id"
# export SPOTIFY_CLIENT_SECRET="your_client_secret"
CLIENT_ID="${SPOTIFY_CLIENT_ID}"
CLIENT_SECRET="${SPOTIFY_CLIENT_SECRET}"

# OpenAI API credentials - Set this as an environment variable:
# export OPENAI_API_KEY="your_openai_api_key"
OPENAI_API_KEY="${OPENAI_API_KEY}"

# Check if credentials are set
if [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ]; then
  echo "Error: SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET environment variables must be set."
  echo "You can get credentials from https://developer.spotify.com/dashboard"
  exit 1
fi

if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: OPENAI_API_KEY environment variable must be set."
  echo "You can get an API key from https://platform.openai.com"
  exit 1
fi

# Path to store previously recommended albums (to avoid duplicates)
HISTORY_FILE="$HOME/.spotify_album_history"
LISTENED_FILE="$HOME/.spotify_album_listened" # File to track listened albums
MAX_HISTORY=500 # Maximum number of albums to keep in history

# Journal configuration
current_date=$(date +"%Y-%m-%d")
current_year=$(date +"%Y")
current_month=$(date +"%B")
file_path="/Users/jamesbest/MyBrain/MyBrain/07_Dev Journal/$current_year/$current_month/$current_date.md"

# ----- Helper Functions -----
# Get Spotify access token
get_access_token() {
  curl -s -X POST "https://accounts.spotify.com/api/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=client_credentials&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET" \
    | jq -r '.access_token'
}

# Check if album is in history
is_in_history() {
  local album_id="$1"
  if [ -f "$HISTORY_FILE" ]; then
    grep -q "$album_id" "$HISTORY_FILE"
    return $?
  fi
  return 1
}

# Add album to history
add_to_history() {
  local album_id="$1"
  local genre="$2"
  echo "$album_id,$genre" >> "$HISTORY_FILE"
  
  # Keep history file to max size
  if [ -f "$HISTORY_FILE" ]; then
    tail -n $MAX_HISTORY "$HISTORY_FILE" > "${HISTORY_FILE}.tmp"
    mv "${HISTORY_FILE}.tmp" "$HISTORY_FILE"
  fi
}

# Check if album has been marked as listened
is_listened() {
  local album_id="$1"
  if [ -f "$LISTENED_FILE" ]; then
    grep -q "$album_id" "$LISTENED_FILE"
    return $?
  fi
  return 1
}

# Mark album as listened
mark_as_listened() {
  local album_id="$1"
  local genre="$2"
  local artist_name="$3"
  local album_name="$4"
  echo "$album_id,$genre,$artist_name,$album_name,$(date +"%Y-%m-%d")" >> "$LISTENED_FILE"
}

# Get AI album recommendation
get_ai_recommendation() {
  local previous_genres=""
  
  # Get last 5 recommended genre types to ensure variety
  if [ -f "$HISTORY_FILE" ]; then
    previous_genres=$(tail -n 5 "$HISTORY_FILE" | cut -d',' -f2 | tr '\n' ',' | sed 's/,$//')
  fi
  
  # Get AI to recommend an album
  local prompt="Recommend a single album that is worth listening to. Make sure it's from a different genre than these recently recommended genres: $previous_genres. Only respond with the artist name and album title in this format: 'Artist Name|Album Title|Genre'. Be specific with the album title and don't make one up."
  
  local response=$(curl -s https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "{
      \"model\": \"gpt-3.5-turbo\",
      \"messages\": [{\"role\": \"system\", \"content\": \"You are a music expert that recommends great albums from various genres.\"}, {\"role\": \"user\", \"content\": \"$prompt\"}],
      \"temperature\": 0.8,
      \"max_tokens\": 100
    }" | jq -r '.choices[0].message.content')
  
  echo "$response"
}

# Search for album on Spotify
search_spotify_album() {
  local artist="$1"
  local album="$2"
  local token="$3"
  
  # URL encode the search query
  local query=$(echo "$artist $album" | sed 's/ /%20/g')
  
  curl -s -X GET "https://api.spotify.com/v1/search?q=$query&type=album&limit=5" \
    -H "Authorization: Bearer $token"
}

# Write album info to journal
write_to_journal() {
  local album_data="$1"
  local genre="$2"
  
  # Extract information using jq
  local album_name=$(echo "$album_data" | jq -r '.name')
  local artist_name=$(echo "$album_data" | jq -r '.artists[0].name')
  local release_date=$(echo "$album_data" | jq -r '.release_date')
  local total_tracks=$(echo "$album_data" | jq -r '.total_tracks')
  local album_url=$(echo "$album_data" | jq -r '.external_urls.spotify')
  local spotify_uri=$(echo "$album_data" | jq -r '.uri')
  local spotify_app_url=$spotify_uri
  local album_id=$(echo "$album_data" | jq -r '.id')
  
  # Format album entry for journal
  local album_text="- ## 🎵 Album of the Day
  - **Album**: $album_name
  - **Artist**: $artist_name
  - **Released**: $release_date
  - **Tracks**: $total_tracks
  - **Genre**: $genre
  - **Listen**: [$artist_name - $album_name]($spotify_app_url) | [Web]($album_url)
  - **Status**: Not listened yet (run \`mark_listened $album_id\` to mark as listened)"
  
  # Escape special characters for Perl
  local escaped_text=$(echo "$album_text" | sed 's/[\/&]/\\&/g')
  
  # Print album info to terminal
  echo "========================================"
  echo "🎵 Your album recommendation for today 🎵"
  echo "Album: $album_name"
  echo "Artist: $artist_name"
  echo "Released: $release_date"
  echo "Tracks: $total_tracks"
  echo "Genre: $genre"
  echo "Listen: $spotify_app_url (Spotify App) or $album_url (Web)"
  echo "Status: Not listened yet (run 'mark_listened $album_id' to mark as listened)"
  echo "========================================"
  
  # If not terminal only mode, append to journal file
  if [ "$TERMINAL_ONLY" = false ]; then
    if [ -f "$file_path" ]; then
      # Use Perl to inject album info in place of [album] tag
      perl -i -p0e "s/\[album\]/$escaped_text/s" "$file_path"
      
      # Check if replacement was successful
      if grep -q "\[album\]" "$file_path"; then
        # If [album] tag wasn't found, append to end of file
        echo "$album_text" >> "$file_path"
        echo "Added album recommendation to the end of your journal: $file_path"
      else
        echo "Replaced [album] tag with album recommendation in: $file_path"
      fi
    else
      echo "Journal file doesn't exist yet: $file_path"
      echo "Will not create file, only showing recommendation in terminal."
    fi
  fi
  
  # Return album ID and other info for potential mark as listened
  echo "$album_id|$artist_name|$album_name"
}

# ----- Command flags -----
# Print to terminal only
if [ "$1" = "--terminal" ] || [ "$1" = "-t" ]; then
  TERMINAL_ONLY=true
else
  TERMINAL_ONLY=false
fi

# ----- Command to mark album as listened -----
if [ "$1" = "mark_listened" ]; then
  if [ -z "$2" ]; then
    echo "Error: Album ID is required"
    echo "Usage: $0 mark_listened <album_id>"
    exit 1
  fi
  
  # Check if the album is in history
  if grep -q "$2" "$HISTORY_FILE"; then
    # Extract genre from history file
    genre=$(grep "$2" "$HISTORY_FILE" | cut -d',' -f2)
    
    # Get album details from Spotify
    ACCESS_TOKEN=$(get_access_token)
    if [ -z "$ACCESS_TOKEN" ]; then
      echo "Error: Failed to obtain Spotify access token. Check your credentials."
      exit 1
    fi
    
    ALBUM_DATA=$(curl -s -X GET "https://api.spotify.com/v1/albums/$2" \
      -H "Authorization: Bearer $ACCESS_TOKEN")
    
    # Extract needed info
    artist_name=$(echo "$ALBUM_DATA" | jq -r '.artists[0].name')
    album_name=$(echo "$ALBUM_DATA" | jq -r '.name')
    
    # Mark as listened
    mark_as_listened "$2" "$genre" "$artist_name" "$album_name"
    echo "✅ Marked '$artist_name - $album_name' ($genre) as listened!"
    
    # Update journal file if it exists for today
    if [ -f "$file_path" ]; then
      # Replace "Not listened" with "Listened"
      sed -i '' "s/Status: Not listened yet (run \`mark_listened $2\` to mark as listened)/Status: ✅ Listened on $(date +"%Y-%m-%d")/" "$file_path"
      echo "Updated journal entry."
    fi
    
    exit 0
  else
    echo "Error: Album ID not found in history. Make sure it's a recommended album."
    exit 1
  fi
fi

# ----- Main Script -----
# Check for required tools
for cmd in curl jq; do
  if ! command -v $cmd &> /dev/null; then
    echo "Error: $cmd is required but not installed. Please install it and try again."
    exit 1
  fi
done

# Get access token
ACCESS_TOKEN=$(get_access_token)
if [ -z "$ACCESS_TOKEN" ]; then
  echo "Error: Failed to obtain Spotify access token. Check your credentials."
  exit 1
fi

# Get AI recommendation
echo "Getting AI album recommendation..."
MAX_ATTEMPTS=5
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
  AI_RECOMMENDATION=$(get_ai_recommendation)
  
  # Parse the recommendation
  ARTIST=$(echo "$AI_RECOMMENDATION" | cut -d'|' -f1 | xargs)
  ALBUM=$(echo "$AI_RECOMMENDATION" | cut -d'|' -f2 | xargs)
  GENRE=$(echo "$AI_RECOMMENDATION" | cut -d'|' -f3 | xargs)
  
  if [ -z "$ARTIST" ] || [ -z "$ALBUM" ]; then
    echo "Failed to get a proper recommendation from AI. Retrying..."
    ATTEMPT=$((ATTEMPT + 1))
    continue
  fi
  
  echo "AI recommended: '$ARTIST - $ALBUM' (Genre: $GENRE)"
  echo "Looking for this album on Spotify..."
  
  # Search for the album on Spotify
  SEARCH_RESULTS=$(search_spotify_album "$ARTIST" "$ALBUM" "$ACCESS_TOKEN")
  ALBUMS_COUNT=$(echo "$SEARCH_RESULTS" | jq -r '.albums.items | length')
  
  if [ "$ALBUMS_COUNT" -eq 0 ]; then
    echo "No matches found on Spotify for '$ARTIST - $ALBUM'. Trying another recommendation..."
    ATTEMPT=$((ATTEMPT + 1))
    continue
  fi
  
  # Get the first album result
  ALBUM_DATA=$(echo "$SEARCH_RESULTS" | jq -r '.albums.items[0]')
  ALBUM_ID=$(echo "$ALBUM_DATA" | jq -r '.id')
  
  # Check if this album is in our history
  if is_in_history "$ALBUM_ID"; then
    echo "Album already recommended before. Finding another..."
    ATTEMPT=$((ATTEMPT + 1))
    continue
  fi
  
  # We found a good album!
  add_to_history "$ALBUM_ID" "$GENRE"
  ALBUM_INFO=$(write_to_journal "$ALBUM_DATA" "$GENRE")
  
  # Show listened command for convenience
  ALBUM_ID=$(echo "$ALBUM_INFO" | cut -d'|' -f1)
  echo ""
  echo "To mark this album as listened after you've heard it, run:"
  echo "$0 mark_listened $ALBUM_ID"
  
  exit 0
done

echo "Failed to find a new album recommendation after $MAX_ATTEMPTS attempts."
echo "Try running the script again later."
exit 1