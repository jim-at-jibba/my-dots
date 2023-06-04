#!/bin/bash

MONTH=$(date +%B)
MONTH_NUMBER=$(date +%m)
YEAR=$(date +%Y)
DATE=$(date +%d-%m)
LOWER_MONTH=$(echo "$MONTH" | tr '[:upper:]' '[:lower:]')

if [[ ! -e /Users/jamesbest/code/other/wiki/diary/${YEAR}/${MONTH_NUMBER}-${LOWER_MONTH}/${DATE}.md ]]; then
	gum confirm "Create new diary for ${DATE}?" && mkdir -p "/Users/jamesbest/code/other/wiki/diary/${YEAR}/${MONTH_NUMBER}-${LOWER_MONTH}" && cp /Users/jamesbest/code/other/wiki/Templates/Diary.md "/Users/jamesbest/code/other/wiki/diary/${YEAR}/${MONTH_NUMBER}-${LOWER_MONTH}/${DATE}.md"
else
	echo "Diary for ${DATE} already exists"
fi
