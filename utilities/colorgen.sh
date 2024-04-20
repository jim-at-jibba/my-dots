#!/bin/zsh

# Check if at least two arguments are given (path and filename)
if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <path to source directory> <filename for colorgen-nvim>"
	exit 1
fi

SOURCE_DIR=$1
FILENAME=$2

# Check if SOURCE_DIR exists
if [ ! -d "$SOURCE_DIR" ]; then
	echo "The source directory does not exist: $SOURCE_DIR"
	exit 1
fi

# Run the colorgen-nvim script with the specified filename
echo "Running colorgen-nvim with $FILENAME..."
colorgen-nvim "$FILENAME" # Assuming colorgen-nvim is executable and in the current path
if [ $? -ne 0 ]; then
	echo "colorgen-nvim script failed. Terminating."
	exit 1
fi

# Define the folders to be copied
FOLDERS=("lua" "colors")

for folder in "${FOLDERS[@]}"; do
	# Remove the folder if it exists in the current directory
	if [ -d "$folder" ]; then
		echo "Removing existing $folder folder..."
		rm -rf "$folder"
	fi

	# Copy the folder from SOURCE_DIR if it exists
	if [ -d "$SOURCE_DIR/$folder" ]; then
		echo "Copying $folder folder from $SOURCE_DIR to current directory..."
		cp -r "$SOURCE_DIR/$folder" .
	else
		echo "The folder $folder does not exist in the source directory."
	fi
done

echo "Operation completed."
