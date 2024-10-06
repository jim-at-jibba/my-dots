#!/bin/bash

input_text_path=$(gum file ~/MyBrain/MyBrain)

echo "Chosen path: $input_text_path"
if gum confirm "Do you want to create flash cards from this content?"; then
  cat "$input_text_path" | fabric --pattern to_flashcards
else
  echo "Operation cancelled."
fi
