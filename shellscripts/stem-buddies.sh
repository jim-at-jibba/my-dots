#!/bin/bash

# Check if both parameters are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <topic> <filename> [--posts-dir <directory>]"
    echo "Example: $0 \"Quantum Computing\" quantum-computing [--posts-dir \"/path/to/posts\"]"
    exit 1
fi

# Assign parameters to variables
TOPIC="$1"
FILENAME="$2"
POSTS_DIR=""

# Check if posts-dir parameter is provided
if [ $# -eq 4 ] && [ "$3" == "--posts-dir" ]; then
    POSTS_DIR="$4"
fi

# Run the first Python script
echo "Generating blog post: $TOPIC"
python /Users/jamesbest/code/other/stem-buddies-creation/main.py "$TOPIC" --filename "$FILENAME" --temperature 0.8 --verbose

# If posts-dir is provided, run the second Python script
if [ -n "$POSTS_DIR" ]; then
    echo "Creating post in directory: $POSTS_DIR"
    python /Users/jamesbest/code/other/stem-buddies-plus/smain.py "$TOPIC" --filename "$FILENAME" --temperature 0.8 --verbose --posts-dir "$POSTS_DIR"
else
    # Run the second script with the default posts directory
    echo "Creating post in default directory"
    python /Users/jamesbest/code/other/stem-buddies-plus/smain.py "$TOPIC" --filename "$FILENAME" --temperature 0.8 --verbose --posts-dir "/Users/jamesbest/code/other/james-best-new/src/pages/blog"
fi

echo "Done!"