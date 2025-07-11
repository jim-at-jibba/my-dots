#!/bin/bash

# Script to setup Claude configuration from template
# Copies ~/dotfiles/ai-stuff/claude/ to .claude/ and merges with existing content

set -e

TEMPLATE_DIR="$HOME/dotfiles/ai-stuff/claude"
TARGET_DIR=".claude"

echo "Setting up Claude configuration..."

# Check if template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Error: Template directory $TEMPLATE_DIR not found"
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Handle settings.json (merge if exists)
if [ -f "$TEMPLATE_DIR/settings.json" ]; then
    if [ -f "$TARGET_DIR/settings.json" ]; then
        echo "Merging settings.json..."
        # Use jq to merge the JSON files
        if command -v jq &> /dev/null; then
            jq -s '.[0] * .[1]' "$TARGET_DIR/settings.json" "$TEMPLATE_DIR/settings.json" > "$TARGET_DIR/settings.json.tmp"
            mv "$TARGET_DIR/settings.json.tmp" "$TARGET_DIR/settings.json"
        else
            echo "  Warning: jq not found, backing up existing settings.json and copying template"
            cp "$TARGET_DIR/settings.json" "$TARGET_DIR/settings.json.backup"
            cp "$TEMPLATE_DIR/settings.json" "$TARGET_DIR/"
        fi
    else
        echo "Copying settings.json..."
        cp "$TEMPLATE_DIR/settings.json" "$TARGET_DIR/"
    fi
fi

# Handle commands directory
if [ -d "$TEMPLATE_DIR/commands" ]; then
    echo "Setting up commands..."
    mkdir -p "$TARGET_DIR/commands"
    
    # Copy all command files from template
    for file in "$TEMPLATE_DIR/commands"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            if [ -f "$TARGET_DIR/commands/$filename" ]; then
                echo "  Skipping $filename (already exists)"
            else
                echo "  Adding $filename"
                cp "$file" "$TARGET_DIR/commands/"
            fi
        fi
    done
fi

# Handle hooks directory
if [ -d "$TEMPLATE_DIR/hooks" ]; then
    echo "Setting up hooks..."
    mkdir -p "$TARGET_DIR/hooks"
    
    # Copy all hook files and directories from template
    for item in "$TEMPLATE_DIR/hooks"/*; do
        if [ -e "$item" ]; then
            basename_item=$(basename "$item")
            if [ -e "$TARGET_DIR/hooks/$basename_item" ]; then
                echo "  Skipping $basename_item (already exists)"
            else
                echo "  Adding $basename_item"
                cp -r "$item" "$TARGET_DIR/hooks/"
            fi
        fi
    done
fi

# Make hook scripts executable
if [ -d "$TARGET_DIR/hooks" ]; then
    find "$TARGET_DIR/hooks" -name "*.py" -exec chmod +x {} \;
    find "$TARGET_DIR/hooks" -name "*.sh" -exec chmod +x {} \;
fi

echo "Claude configuration setup complete!"
echo "Template files copied to $TARGET_DIR/"