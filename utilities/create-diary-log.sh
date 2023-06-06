#!/bin/bash

LOG=$(gum input --placeholder "Say something")
MONTH=$(date +%B)
MONTH_NUMBER=$(date +%m)
YEAR=$(date +%Y)
DATE=$(date +%d-%m)
TIME=$(date +%H:%M)
LOWER_MONTH=$(echo "$MONTH" | tr '[:upper:]' '[:lower:]')

if [[ -e /Users/jamesbest/code/other/wiki/diary/${YEAR}/${MONTH_NUMBER}-${LOWER_MONTH}/${DATE}.md ]]; then
	if [[ -z "$LOG" ]]; then
		echo "No log provided"
		exit 1
	fi
	echo "[${TIME}]: ${LOG}" >>"/Users/jamesbest/code/other/wiki/diary/${YEAR}/${MONTH_NUMBER}-${LOWER_MONTH}/${DATE}.md"
else
	echo "Diary for ${DATE} does not exist exists"
fi
