#!/usr/bin/bash

TIMESTAMP=$(date +%s)

# Prompt for a base name
echo -n "Enter the base name for the tabs:"
read BASE_NAME

if [ -z "$BASE_NAME" ]; then
	BASE_NAME="dev"
fi


SESSION_NAME="${BASE_NAME}_${TIMESTAMP}"

# Start a new tmux session named 'dev' or attach to it if it exists
# -d detaches from any existing client
# -A attaches if the session exists, otherwise creates it
tmux new-session -d -s $SESSION_NAME

# Rename the first window (tab)
tmux rename-window -t $SESSION_NAME:1 "${BASE_NAME}_main"

# Create a second window (tab)
tmux new-window -t $SESSION_NAME:2 -n "${BASE_NAME}_second"

# Create a second window (tab)
tmux new-window -t $SESSION_NAME:3 -n "${BASE_NAME}_third"

# You can add commands to run in specific windows
# For example, run htop in the second window
# tmux send-keys -t dev:1 'htop' C-m

# Select the first window
tmux select-window -t $SESSION_NAME:0

if [ "$1" == "alacritty" ]; then
	alacritty -e tmux attach-session -t $SESSION_NAME
else
	tmux attach-session -t $SESSION_NAME
fi
