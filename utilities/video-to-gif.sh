#!/usr/bin/env bash

# Convert video to GIF using FFmpeg
# Usage: video-to-gif.sh <input_video> [output_gif] [fps] [width]

set -euo pipefail

# Check if input file is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input_video> [output_gif] [fps] [width]"
    echo ""
    echo "Arguments:"
    echo "  input_video  - Path to the input video file (required)"
    echo "  output_gif   - Path to output GIF file (default: input filename with .gif extension)"
    echo "  fps          - Frames per second (default: 15)"
    echo "  width        - Width in pixels, height auto-calculated (default: 480)"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="${2:-${INPUT_FILE%.*}.gif}"
FPS="${3:-15}"
WIDTH="${4:-480}"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found"
    exit 1
fi

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Please install it first."
    exit 1
fi

echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE'..."
echo "Settings: FPS=$FPS, Width=$WIDTH"

# Generate palette for better quality
PALETTE="/tmp/palette-$$.png"

ffmpeg -i "$INPUT_FILE" -vf "fps=$FPS,scale=$WIDTH:-1:flags=lanczos,palettegen" -y "$PALETTE"

# Convert to GIF using the palette
ffmpeg -i "$INPUT_FILE" -i "$PALETTE" -filter_complex "fps=$FPS,scale=$WIDTH:-1:flags=lanczos[x];[x][1:v]paletteuse" -y "$OUTPUT_FILE"

# Clean up palette
rm "$PALETTE"

echo "Done! GIF saved to: $OUTPUT_FILE"
