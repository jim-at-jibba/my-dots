#!/bin/sh

FILE=$(gum file /Users/jamesbest/code/other/wiki/breedr/tasks/)
gum confirm "Move $FILE?" && mv $FILE /Users/jamesbest/code/other/wiki/breedr/tasks/archive/
