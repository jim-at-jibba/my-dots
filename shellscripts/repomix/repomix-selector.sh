#!/bin/bash

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "Error: fzf is not installed. Please install it first."
    echo "You can install it with:"
    echo "  brew install fzf    # on macOS with Homebrew"
    echo "  apt install fzf     # on Debian/Ubuntu"
    echo "  dnf install fzf     # on Fedora"
    exit 1
fi

# Check if repomix is installed
if ! command -v repomix &> /dev/null; then
    echo "Warning: repomix doesn't appear to be installed or is not in your PATH."
    echo "This script will still collect files but might not be able to run repomix."
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Function to select files/directories with fzf and convert to glob pattern
select_and_convert_to_glob() {
    # Create a temporary file to store selected items
    selected_file=$(mktemp)
    
    # Display both files and directories for selection
    find . -type f -o -type d | grep -v "/\." | sort | fzf --multi --preview '
        if [ -d {} ]; then
            ls -la {}
        else
            file --mime {} | grep -q "text/" && bat --color=always --line-range :50 {} || echo "Binary file"
        fi
    ' > "$selected_file"
    
    # Check if any items were selected
    if [[ ! -s "$selected_file" ]]; then
        echo "No items selected. Exiting."
        rm "$selected_file"
        return 1
    fi
    
    # Convert selections to glob patterns
    pattern_file=$(mktemp)
    
    while IFS= read -r item; do
        # Remove leading ./ if present
        item="${item#./}"
        
        # If it's a directory, add "/**" pattern
        if [[ -d "$item" ]]; then
            echo "$item/**" >> "$pattern_file"
        else
            # For files, add them directly
            echo "$item" >> "$pattern_file"
        fi
    done < "$selected_file"
    
    # Join all patterns with commas
    glob_pattern=$(tr '\n' ',' < "$pattern_file" | sed 's/,$//')
    
    # Clean up temporary files
    rm "$selected_file" "$pattern_file"
    
    # Return the glob pattern
    echo "$glob_pattern"
}

# Function to run repomix with the whole current directory
run_whole_directory() {
    echo "Running repomix for the whole current directory..."
    repomix --copy
}

# Function to run repomix with include pattern
run_with_include() {
    echo "Select files/directories to INCLUDE:"
    include_pattern=$(select_and_convert_to_glob)
    
    if [[ -n "$include_pattern" ]]; then
        echo "Running repomix with --include \"$include_pattern\""
        repomix --copy --include "$include_pattern"
    else
        echo "No include pattern generated. Exiting."
        return 1
    fi
}

# Function to run repomix with ignore pattern
run_with_ignore() {
    echo "Select files/directories to IGNORE:"
    ignore_pattern=$(select_and_convert_to_glob)
    
    if [[ -n "$ignore_pattern" ]]; then
        echo "Running repomix with --ignore \"$ignore_pattern\""
        repomix --copy --ignore "$ignore_pattern"
    else
        echo "No ignore pattern generated. Exiting."
        return 1
    fi
}

# Function to run repomix with both include and ignore patterns
run_with_include_and_ignore() {
    echo "Select files/directories to INCLUDE:"
    include_pattern=$(select_and_convert_to_glob)
    
    if [[ -z "$include_pattern" ]]; then
        echo "No include pattern generated. Exiting."
        return 1
    fi
    
    echo "Select files/directories to IGNORE:"
    ignore_pattern=$(select_and_convert_to_glob)
    
    if [[ -z "$ignore_pattern" ]]; then
        echo "No ignore pattern generated. Exiting."
        return 1
    fi
    
    echo "Running repomix with --include \"$include_pattern\" --ignore \"$ignore_pattern\""
    repomix --copy --include "$include_pattern" --ignore "$ignore_pattern"
}

# Main menu
show_menu() {
    echo "RepofZF - FZF Selector for Repomix"
    echo "=================================="
    echo "1. Run for whole current directory"
    echo "2. Select files/directories to include"
    echo "3. Select files/directories to ignore"
    echo "4. Select both include and ignore patterns"
    echo "q. Quit"
    echo
    read -p "Select an option (1-4, q): " option
    
    case $option in
        1)
            run_whole_directory
            ;;
        2)
            run_with_include
            ;;
        3)
            run_with_ignore
            ;;
        4)
            run_with_include_and_ignore
            ;;
        q|Q)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            show_menu
            ;;
    esac
}

# Handle command line arguments
if [[ $# -eq 0 ]]; then
    # No arguments, show menu
    show_menu
else
    # Handle arguments
    case "$1" in
        "include")
            run_with_include
            ;;
        "ignore")
            run_with_ignore
            ;;
        "both")
            run_with_include_and_ignore
            ;;
        *)
            echo "Invalid argument. Valid options are: include, ignore, both"
            exit 1
            ;;
    esac
fi