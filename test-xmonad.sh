#!/usr/bin/env bash
# 1. Kill any existing Xephyr instances to avoid conflicts
killall Xephyr 2>/dev/null
# 2. Launch Xephyr
Xephyr -br -ac -noreset -screen 1280x720 :1 &
sleep 2

# 3. EXPLICITLY RUN THE COMPILED BINARY
# We do NOT use --config here because the binary already knows its own code.
DISPLAY=:1 ~/.xmonad/xmonad-x86_64-linux
