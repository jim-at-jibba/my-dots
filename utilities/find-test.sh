#!/bin/bash

# Function to run test based on file extension
run_test_for_file() {
	file="$1"
	extension="${file##*.}"

	case "$extension" in
	js)
		echo "Running JavaScript test for $file"
		yarn test --silent -i "$file"
		;;
	ts)
		echo "Running JavaScript test for $file"
		yarn test --silent -i "$file"
		;;
	tsx)
		echo "Running JavaScript test for $file"
		yarn test --silent -i "$file"
		;;
	py)
		echo "Running Python test for $file"
		pytest "$file"
		;;
	# Add more file types as needed
	*)
		echo "No specific test command for files of type .$extension"
		;;
	esac
}

export -f run_test_for_file

# Find files excluding certain directories and picking up test files, then allow user selection
selected_files=$(rg -g '!./node_modules/**' -g '!./vendor/**' -g '!./ios/**' -g '*test*' --files | gum filter)

# Check if user made a selection
if [ -z "$selected_files" ]; then
	echo "No files were selected."
	exit 1
fi

# Run test command for the selected files
echo "$selected_files" | xargs -L 1 bash -c 'run_test_for_file "$@"' bash
