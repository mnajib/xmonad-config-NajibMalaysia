#!/usr/bin/env bash
# ~/.xmonad/bin/start-generator.sh
# Only starts the generator, display is managed by xmobar

# Kill existing generator
pkill -f waktusolat-generator 2>/dev/null

# Wait for cleanup
sleep 0.5

# Create required directories
mkdir -p /run/user/$(id -u)/waktusolat
#mkdir -p /run/waktusolat

# Start generator with nohup
nohup $HOME/.xmonad/bin/waktusolat-generator.sh > /dev/null 2>&1 &
#$HOME/.xmonad/bin/waktusolat-generator.sh > /dev/null 2>&1 &

# Verify it started
sleep 1
if pgrep -f waktusolat-generator > /dev/null; then
    echo "waktusolat-generator started successfully"
else
    echo "ERROR: waktusolat-generator failed to start"
    # Try without nohup as fallback
    $HOME/.xmonad/bin/waktusolat-generator.sh &
fi

#nohup xmobar --screen=0 --position=top $HOME/.xmonad/xmobarrc-waktuSolat.hs > /dev/null 2>&1 &
