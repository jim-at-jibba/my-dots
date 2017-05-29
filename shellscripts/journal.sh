#!/bin/bash
# Creates journal first thing and then adds time to the file every hour

vim ~/Dropbox/VimWiki/tech.wiki/diary/$(date +'%Y-%m-%d').mkd +"$ | put! = '$(date +'%H:%M:%S')'"












