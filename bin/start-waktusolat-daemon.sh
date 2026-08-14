#!/usr/bin/env bash
# ~/.xmonad/bin/start-waktusolat-daemon.sh
# This script ensures waktusolat processes stay running

# Kill any existing instances
pkill -f "waktusolat-generator"
pkill -f "waktusolat-display"
pkill -f "waktusolat"

# Wait for cleanup
sleep 1

# Create required directories
mkdir -p /run/user/$(id -u)/waktusolat
mkdir -p /run/waktusolat

# Start generator with nohup to survive parent death
nohup $HOME/.xmonad/bin/waktusolat-generator.sh > /dev/null 2>&1 &
GENERATOR_PID=$!

# Start display with nohup
nohup $HOME/.xmonad/bin/waktusolat-display.sh > /dev/null 2>&1 &
DISPLAY_PID=$!

# Wait a moment to ensure they started
sleep 1

# Verify they're running
if ps -p $GENERATOR_PID > /dev/null 2>&1; then
    echo "waktusolat-generator started (PID: $GENERATOR_PID)"
else
    echo "ERROR: waktusolat-generator failed to start"
    # Try alternative: run directly without nohup
    $HOME/.xmonad/bin/waktusolat-generator.sh &
fi

if ps -p $DISPLAY_PID > /dev/null 2>&1; then
    echo "waktusolat-display started (PID: $DISPLAY_PID)"
else
    echo "ERROR: waktusolat-display failed to start"
    $HOME/.xmonad/bin/waktusolat-display.sh &
fi

# Save PIDs for later checking
echo $GENERATOR_PID > /tmp/waktusolat-generator.pid
echo $DISPLAY_PID > /tmp/waktusolat-display.pid
