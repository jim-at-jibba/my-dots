#!/usr/bin/env bash

# Convert MOV files to MP4 using FFmpeg
# Usage: mov-to-mp4.sh <input_file> [output_file]

set -euo pipefail

if [ $# -lt 1 ]; then
	echo "Usage: $0 <input_file> [output_file]"
	echo ""
	echo "Arguments:"
	echo "  input_file   - Path to the input MOV file (required)"
	echo "  output_file  - Path to output MP4 file (default: input filename with .mp4 extension)"
	exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${2:-${INPUT_FILE%.*}.mp4}"

if [ ! -f "$INPUT_FILE" ]; then
	echo "Error: Input file '$INPUT_FILE' not found"
	exit 1
fi

if ! command -v ffmpeg &>/dev/null; then
	echo "Error: ffmpeg is not installed. Please install it first."
	exit 1
fi

echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE'..."

ffmpeg -i "$INPUT_FILE" -c:v libx264 -c:a aac -movflags +faststart -y "$OUTPUT_FILE"

echo "Done! MP4 saved to: $OUTPUT_FILE"
