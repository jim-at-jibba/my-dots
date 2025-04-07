#!/bin/bash

# Daily Spotify Album Recommendation
# This script uses the Spotify API to recommend a random album each day
# and adds it to your journal file

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

# Path to store previously recommended albums (to avoid duplicates)
HISTORY_FILE="$HOME/.spotify_album_history"
MAX_HISTORY=100 # Maximum number of albums to keep in history

# Journal configuration - exact path from your script
current_date=$(date +"%Y-%m-%d")
current_year=$(date +"%Y")
current_month=$(date +"%B")
file_path="/Users/jamesbest/MyBrain/MyBrain/07_Dev Journal/$current_year/$current_month/$current_date.md"

# Genre seeds to choose from - add/remove genres as preferred
GENRES=(
  "alternative" "ambient" "blues" "classical" "country" "electronic"
  "folk" "funk" "hip-hop" "indie" "jazz" "metal" "pop" "punk" "rock"
)

# ----- Helper Functions -----
# Get Spotify access token
get_access_token() {
  curl -s -X POST "https://accounts.spotify.com/api/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=client_credentials&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET" \
    | jq -r '.access_token'
}

# Get random genre from our list
get_random_genre() {
  echo "${GENRES[$RANDOM % ${#GENRES[@]}]}"
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
  echo "$album_id" >> "$HISTORY_FILE"
  
  # Keep history file to max size
  if [ -f "$HISTORY_FILE" ]; then
    tail -n $MAX_HISTORY "$HISTORY_FILE" > "${HISTORY_FILE}.tmp"
    mv "${HISTORY_FILE}.tmp" "$HISTORY_FILE"
  fi
}

# Write album info to journal
write_to_journal() {
  local album_data="$1"
  
  # Extract information using jq
  local album_name=$(echo "$album_data" | jq -r '.name')
  local artist_name=$(echo "$album_data" | jq -r '.artists[0].name')
  local release_date=$(echo "$album_data" | jq -r '.release_date')
  local total_tracks=$(echo "$album_data" | jq -r '.total_tracks')
  local album_url=$(echo "$album_data" | jq -r '.external_urls.spotify')
  
  # Format album entry for journal
  local album_text="- ## 🎵 Album of the Day
  - **Album**: $album_name
  - **Artist**: $artist_name
  - **Released**: $release_date
  - **Tracks**: $total_tracks
  - **Listen**: [$artist_name - $album_name]($album_url)"
  
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
    echo "Listen: $album_url"
    echo "========================================"
  fi
}

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

# Get a random genre
GENRE=$(get_random_genre)
echo "Looking for an album in the '$GENRE' genre..."

# Get recommendations
MAX_ATTEMPTS=5
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
  # First, check how many albums are available for the genre
  CHECK_RESPONSE=$(curl -s -X GET "https://api.spotify.com/v1/search?q=genre:$GENRE&type=album&limit=1&offset=0" \
    -H "Authorization: Bearer $ACCESS_TOKEN")
  TOTAL_ALBUMS=$(echo "$CHECK_RESPONSE" | jq -r '.albums.total')

  if [ "$TOTAL_ALBUMS" -eq 0 ]; then
    echo "No albums found for genre '$GENRE'. Trying another genre..."
    GENRE=$(get_random_genre)
    ATTEMPT=$((ATTEMPT + 1))
    continue
  fi

  # Calculate a valid max offset (Spotify limit is high, but let's cap at 950 for safety)
  # We need at least 50 results (our limit), so max offset is total - 50
  MAX_OFFSET_CALC=$((TOTAL_ALBUMS - 50))
  MAX_OFFSET_LIMIT=950 # Safe upper bound
  MAX_OFFSET=$(( MAX_OFFSET_CALC < MAX_OFFSET_LIMIT ? MAX_OFFSET_CALC : MAX_OFFSET_LIMIT ))
  # Ensure max_offset isn't negative if total_albums < 50
  if [ $MAX_OFFSET -lt 0 ]; then
      MAX_OFFSET=0
  fi
  
  # Get a random offset within the valid range
  OFFSET=$((RANDOM % (MAX_OFFSET + 1)))
  
  echo "Searching genre '$GENRE' with offset $OFFSET (max possible: $MAX_OFFSET based on $TOTAL_ALBUMS total)..."

  # Get albums from Spotify using the calculated offset
  RESPONSE=$(curl -s -X GET "https://api.spotify.com/v1/search?q=genre:$GENRE&type=album&limit=50&offset=$OFFSET" \
    -H "Authorization: Bearer $ACCESS_TOKEN")
  
  # Check if we got albums (redundant check based on previous logic, but good practice)
  ALBUMS_COUNT=$(echo "$RESPONSE" | jq -r '.albums.items | length')
  
  if [ "$ALBUMS_COUNT" -eq 0 ]; then
      echo "No album items returned for genre '$GENRE' at offset $OFFSET. Trying again..."
      GENRE=$(get_random_genre) # Pick a new genre to potentially avoid offset issues
      ATTEMPT=$((ATTEMPT + 1))
      continue
  fi
  
  ALBUM_INDEX=$((RANDOM % ALBUMS_COUNT))
  ALBUM=$(echo "$RESPONSE" | jq -r ".albums.items[$ALBUM_INDEX]")
  ALBUM_ID=$(echo "$ALBUM" | jq -r '.id')
  
  # Check if this album is in our history
  if is_in_history "$ALBUM_ID"; then
    echo "Album already recommended before. Finding another..."
    ATTEMPT=$((ATTEMPT + 1))
    continue
  fi
  
  # We found a good album!
  add_to_history "$ALBUM_ID"
  write_to_journal "$ALBUM"
  exit 0
done

echo "Failed to find a new album recommendation after $MAX_ATTEMPTS attempts."
echo "Try running the script again or adding more genres to the list."
exit 1