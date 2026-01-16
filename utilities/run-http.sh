#!/bin/bash

http_dir=$(find . -maxdepth 3 -type d -name "http" 2>/dev/null | head -1)

if [ -z "$http_dir" ]; then
	echo "No 'http' directory found"
	exit 1
fi

selected_file=$(find "$http_dir" -type f -name "*.http" | fzf --preview 'cat {}')

if [ -z "$selected_file" ]; then
	echo "No file selected"
	exit 1
fi

httpyac "$selected_file"
