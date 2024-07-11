#!/bin/bash

# Define the source and destination directories
src_dir="/path/to/source/directory"
dest_dir="/path/to/destination/directory"

# Get the list of files to be committed
files_to_commit=$(git diff --cached --name-only)

# Loop over the files
for file in $files_to_commit; do
  # Check if the file is in the source directory
  if [[ $file == $src_dir* ]]; then
    # Copy the file to the destination directory
    cp $file $dest_dir/${file#$src_dir/}
  fi
done

# Change to the destination directory
cd $dest_dir

# Add all the copied files to the staging area
git add .

# Commit the changes
git commit -m "Auto commit from pre-commit hook"
