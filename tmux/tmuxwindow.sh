#!/usr/bin/bash

# Start a new tmux session named 'dev' or attach to it if it exists
# -d detaches from any existing client
# -A attaches if the session exists, otherwise creates it
tmux new-session -d -s dev

# Rename the first window (tab)
tmux rename-window -t dev:1 'main'

# Create a second window (tab)
tmux new-window -t dev:2 -n 'second'

# You can add commands to run in specific windows
# For example, run htop in the second window
# tmux send-keys -t dev:1 'htop' C-m

# Select the first window
tmux select-window -t dev:0

# Attach to the session
tmux attach-session -t dev

alacritty -e tmux attach-session -t dev
