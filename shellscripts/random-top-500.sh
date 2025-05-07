#!/bin/bash

# Rolling Stone 500 Album Recommendation
# This script uses the Spotify API to recommend albums from Rolling Stone's 500 Greatest Albums list
# and adds them to your journal file

# ----- Configuration -----
# Spotify API credentials - Set these as environment variables:
# export SPOTIFY_CLIENT_ID="your_client_id"
# export SPOTIFY_CLIENT_SECRET="your_client_secret"
CLIENT_ID="${SPOTIFY_CLIENT_ID}"
CLIENT_SECRET="${SPOTIFY_CLIENT_SECRET}"

# Check if credentials are set
if [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ]; then
  echo "Error: SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET environment variables must be set."
  echo "You can get credentials from https://developer.spotify.com/dashboard"
  exit 1
fi

# Path to the Rolling Stone 500 CSV file
RS500_CSV="$HOME/.rolling_stone_500.csv"

# Check if the CSV file exists
if [ ! -f "$RS500_CSV" ]; then
  echo "Error: Rolling Stone 500 CSV file not found at $RS500_CSV"
  echo "Please place the CSV file at this location."
  exit 1
fi

# Path to store previously recommended albums (to avoid duplicates)
HISTORY_FILE="$HOME/.spotify_album_history"
LISTENED_FILE="$HOME/.spotify_album_listened" # New file to track listened albums
MAX_HISTORY=500 # Maximum number of albums to keep in history (increased to accommodate all 500 albums)

# Journal configuration - exact path from your script
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
  local rs_rank="$2"
  echo "$album_id,$rs_rank" >> "$HISTORY_FILE"
  
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
  local rs_rank="$2"
  local artist_name="$3"
  local album_name="$4"
  echo "$album_id,$rs_rank,$artist_name,$album_name,$(date +"%Y-%m-%d")" >> "$LISTENED_FILE"
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
  local rs_rank="$2"
  
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
  local album_text="- **Album**: $album_name
  - **Artist**: $artist_name
  - **Released**: $release_date
  - **Tracks**: $total_tracks
  - **Rolling Stone Rank**: #$rs_rank
  - **Listen**: [$artist_name - $album_name]($spotify_app_url) | [Web]($album_url)
  - **Status**: Not listened yet (run \`mark_listened $album_id\` to mark as listened)"
  
  # Escape special characters for Perl
  local escaped_text=$(echo "$album_text" | sed 's/[\/&]/\\&/g')
  
  # Append to journal file if it exists
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
    echo "Will not create file, just recommend album in terminal:"
    echo "========================================"
    echo "🎵 Your album recommendation for today 🎵"
    echo "Album: $album_name"
    echo "Artist: $artist_name"
    echo "Released: $release_date"
    echo "Tracks: $total_tracks"
    echo "Rolling Stone Rank: #$rs_rank"
    echo "Listen: $spotify_app_url (Spotify App) or $album_url (Web)"
    echo "Status: Not listened yet (run 'mark_listened $album_id' to mark as listened)"
    echo "========================================"
  fi
  
  # Return album ID and other info for potential mark as listened
  echo "$album_id|$artist_name|$album_name"
}

# ----- Command to mark album as listened -----
if [ "$1" = "mark_listened" ]; then
  if [ -z "$2" ]; then
    echo "Error: Album ID is required"
    echo "Usage: $0 mark_listened <album_id>"
    exit 1
  fi
  
  # Check if the album is in history
  if grep -q "$2" "$HISTORY_FILE"; then
    # Extract RS rank from history file
    rs_rank=$(grep "$2" "$HISTORY_FILE" | cut -d',' -f2)
    
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
    mark_as_listened "$2" "$rs_rank" "$artist_name" "$album_name"
    echo "✅ Marked '$artist_name - $album_name' (Rank #$rs_rank) as listened!"
    
    # Update journal file if it exists for today
    if [ -f "$file_path" ]; then
      # Replaced "Not listened" with "Listened"
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

# Get total number of albums in history
TOTAL_RECOMMENDED=0
if [ -f "$HISTORY_FILE" ]; then
  TOTAL_RECOMMENDED=$(cat "$HISTORY_FILE" | wc -l | tr -d ' ')
fi

if [ "$TOTAL_RECOMMENDED" -ge 500 ]; then
  echo "You have already gone through all 500 albums from the Rolling Stone list!"
  echo "Consider resetting your history file if you want to start over."
  exit 0
fi

# Get a list of ranks that have not been recommended
MAX_ATTEMPTS=10
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
  # Create a temporary file with RS ranks that haven't been recommended yet
  AVAILABLE_RANKS=$(mktemp)
  
  # Generate all possible ranks (1-500)
  for i in $(seq 1 500); do
    if ! grep -q ",$i$" "$HISTORY_FILE" 2>/dev/null; then
      echo $i >> "$AVAILABLE_RANKS"
    fi
  done
  
  # Count how many ranks are available
  RANKS_COUNT=$(cat "$AVAILABLE_RANKS" | wc -l | tr -d ' ')
  
  if [ "$RANKS_COUNT" -eq 0 ]; then
    echo "No more albums to recommend from the Rolling Stone 500 list!"
    rm "$AVAILABLE_RANKS"
    exit 0
  fi
  
  # Pick a random rank from the available ones
  RANK_INDEX=$((1 + RANDOM % RANKS_COUNT))
  RS_RANK=$(sed "${RANK_INDEX}q;d" "$AVAILABLE_RANKS")
  
  # Clean up temporary file
  rm "$AVAILABLE_RANKS"
  
  echo "Selected album rank #$RS_RANK from Rolling Stone 500 list..."
  
  # Get artist and album from the CSV
  ALBUM_LINE=$(sed "${RS_RANK}q;d" "$RS500_CSV")
  ARTIST=$(echo "$ALBUM_LINE" | cut -d, -f2)
  ALBUM=$(echo "$ALBUM_LINE" | cut -d, -f3)
  
  echo "Looking for '$ARTIST - $ALBUM' on Spotify..."
  
  # Search for the album on Spotify
  SEARCH_RESULTS=$(search_spotify_album "$ARTIST" "$ALBUM" "$ACCESS_TOKEN")
  ALBUMS_COUNT=$(echo "$SEARCH_RESULTS" | jq -r '.albums.items | length')
  
  if [ "$ALBUMS_COUNT" -eq 0 ]; then
    echo "No matches found on Spotify for '$ARTIST - $ALBUM'. Trying another album..."
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
  add_to_history "$ALBUM_ID" "$RS_RANK"
  ALBUM_INFO=$(write_to_journal "$ALBUM_DATA" "$RS_RANK")
  
  # Show listened command for convenience
  ALBUM_ID=$(echo "$ALBUM_INFO" | cut -d'|' -f1)
  echo ""
  echo "To mark this album as listened after you've heard it, run:"
  echo "$0 mark_listened $ALBUM_ID"
  
  exit 0
done

echo "Failed to find a new album recommendation after $MAX_ATTEMPTS attempts."
echo "Try running the script again or check if the CSV format is correct."
exit 1