---
description: Download YouTube playlist as organized MP3 files
arguments:
  - name: playlist_url
    description: YouTube playlist URL to download
    required: true
---

Download the YouTube playlist at $ARGUMENTS as individual MP3 tracks. Create a folder named after the album in ~/Music, download all tracks with proper naming (track numbers and titles), embed metadata including artist, album, and track information, and organize the files ready for import into Apple Music. Use yt-dlp with best audio quality available and ensure all files have consistent tagging. Use ffmpeg to fix and standardize metadata tags. Ensure track numbers match the correct album order, not just the playlist order.
