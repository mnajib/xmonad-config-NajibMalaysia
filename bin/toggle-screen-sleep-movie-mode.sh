#!/usr/bin/env bash
# Toggle screen sleep/blanking for movie mode and write status for XMobar

status_file="/tmp/${USER}-movie-mode-status"

# Check current DPMS state
dpms_state=$(xset q | grep "DPMS is" | awk '{print $3}')

if [[ "$dpms_state" == "Enabled" ]]; then
    # Disable screen blanking and DPMS (for movies)
    xset s off
    xset -dpms
    notify-send "Movie Mode ON" "Screen sleep/blanking DISABLED"
    echo "ON" > "$status_file"  # Write status for XMobar
else
    # Re-enable defaults
    xset s on
    xset +dpms
    notify-send "Movie Mode OFF" "Screen sleep/blanking RESTORED"
    echo "OFF" > "$status_file"  # Write status for XMobar
fi
