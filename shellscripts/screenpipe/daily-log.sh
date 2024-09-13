#!/bin/bash

# Constants
OPENAI_API_URL="http://localhost:11434/api/chat"
OPENAI_MODEL="phi"
SCREENPIPE_API_URL="http://localhost:3030/search"
LOG_INTERVAL=$((1 * 60)) # 1 minute in seconds

# Function to get OpenAI key
get_openai_key() {
  local secrets_path="$HOME/secrets.json"

  if [ -f "$secrets_path" ]; then
    cat "$secrets_path" | jq -r '.OPENAI_API_KEY'
  else
    echo "$OPENAI_API_KEY"
  fi
}

# Function to query Screenpipe
query_screenpipe() {
  local start_time="$1"
  local end_time="$2"
  local url="${SCREENPIPE_API_URL}?start_time=${start_time}&end_time=${end_time}&limit=100&content_type=ocr"

  echo "Querying Screenpipe: $url"
  curl -s "$url"
}

# Function to generate log entry
generate_log_entry() {
  local prompt="$1"
  echo "🪚 prompt: $prompt" >&2
  local data="$2"
  local openai_key=$(get_openai_key)
  echo "🪚 openai_key: $openai_key" >&2

  local response=$(curl -s -X POST "$OPENAI_API_URL" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $openai_key" \
    -d '{
      "model": "'"$OPENAI_MODEL"'",
      "stream": false,
      "messages": []
    }')

  echo "🪚 response: $response" >&2
  echo "$response" | jq -r '.choices[0].message.content // .message.content'
}

# Function to append to log file
append_to_log_file() {
  local log="$1"
  local date=$(date +%Y-%m-%d)
  local file_name="daily_log_${date}.md"

  echo -e "$log\n\n" >>"$file_name"
}

# Function to start logging
start_logging() {
  local tracking_prompt="$1"

  echo "Starting to log activities. Tracking: $tracking_prompt"

  while true; do
    local end_time=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local start_time=$(date -u -v-${LOG_INTERVAL}S +"%Y-%m-%dT%H:%M:%SZ")

    local screenpipe_data=$(query_screenpipe "$start_time" "$end_time")
    local log_entry=$(generate_log_entry "$tracking_prompt" "$screenpipe_data")

    if [ -n "$log_entry" ]; then
      append_to_log_file "$log_entry"
      echo "Log entry added"
    else
      echo "Error generating log entry"
    fi

    sleep "$LOG_INTERVAL"
  done
}

# Main execution
read -p "What aspects of your day do you want to track? " tracking_prompt
start_logging "$tracking_prompt"
