#!/bin/sh

INPUT=$(gum input --placeholder "Name of task")
TASK_NUMBER=$(gum input --placeholder "Task number")
TASK_URL=$(gum input --placeholder "Task URL")

sed "s,\[Task Name\],$INPUT,g; s,\[Ticket\],[$TASK_NUMBER],g; s,(),($TASK_URL),g" /Users/jamesbest/code/other/wiki/Templates/Task.md > /Users/jamesbest/code/other/wiki/breedr/tasks/${INPUT}.md
