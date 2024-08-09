#!/bin/bash

# Define the source and destination directories
src_dir="/Users/jamesbest/code/other/wiki"
dest_dir="/Users/jamesbest/code/work/fe-til"

# Get the list of files to be committed
files_to_commit=$(git diff --cached --name-only)
echo "what" $files_to_commit

# Loop over the files
for file in $files_to_commit; do
  echo "file" $file
  # Check if the file is in the source directory
  if [[ $src_dir$file == $src_dir* ]]; then
    # Copy the file to the destination directory
    echo "Copying $src_dir/$file to $dest_dir/${file#*/}"
    cp $src_dir/$file $dest_dir/${file#*/}
  fi
done

# Change to the destination directory
cd $dest_dir

# Add all the copied files to the staging area
git add .

# use ai to generate commit message
msg="$(git diff --staged | sgpt "Generate a concise git commit message that summarizes the key changes. Stay high-level and combine smaller changes to overarching topics. Skip describing any reformatting changes. For example, 'Add new feature, refactor existing code, and fix bug")"
PREFIXED_MSG="${msg}"
echo ${PREFIXED_MSG}
# Commit the changes
git commit -m "${PREFIXED_MSG}"
