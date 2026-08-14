#!/usr/bin/env bash
# bin/waktusolat-display.sh
# Sub-Job 2: Reads reminder.xmobar and streams directly to Xmobar stdout

BASE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
REMINDER_XMOBAR="${BASE_DIR}/waktusolat/reminder.xmobar"

# Force unbuffered output stream
exec 1> >(stdbuf -oL cat)

while true; do
    if [[ -f "$REMINDER_XMOBAR" && -s "$REMINDER_XMOBAR" ]]; then
        cat "$REMINDER_XMOBAR"
    else
        echo "Waiting for reminder.xmobar..."
    fi
    sleep 1
done
