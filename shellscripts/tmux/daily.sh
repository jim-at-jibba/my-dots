#!/usr/local/bin/zsh
SESSION="Daily"

# C-m = carrage return

# creates new session remain detached
tmux -2 new-session -d -s $SESSION

# create window called daily
tmux rename-window -t  daily

# split window horizontally
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "echo pane 0" C-m
tmux split-window -v
tmux select-pane -t 1
tmux send-keys "echo pane 1" C-m

# create new window for irc 
#tmux new-window -t irc





# Set default window
tmux select-window -t $SESSION:1

# Attach to session
tmux -2 attach-session -t $SESSION