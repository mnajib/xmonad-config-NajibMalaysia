#!/usr/bin/env bash

status_file="/tmp/${USER}-movie-mode-status"

# UP
FgColor1="#000000"
BgColor1="#ff0000"
# DOWN
FgColor2="#646464"
BgColor2="#ff0000"

onColor="${FgColor1},${BgColor1}"
offColor="${FgColor2}"

#dpms_state=$(xset q | grep "DPMS is" | awk '{print $3}')

set_moviemode_on() {
    # Disables both screen blanking and Display Power Management Signaling (DPMS)
    #   xset s off: Turns off the screen saver (prevents blanking due to inactivity).
    #   xset -dpms: Disables monitor power-saving features (no standby/suspend/off modes)
    xset s off && xset -dpms
    echo "<action=\`~/.xmonad/bin/toggle-screen-sleep-movie-mode-v2.sh\`><fc=${onColor}>Movie</fc></action>" > "$status_file"  # Red highlight
}

set_moviemode_off() {
    # Re-enables both screen blanking and DPMS:
    #   xset s on: Turns the screen saver back on.
    #   xset +dpms: Enables monitor power-saving features.
    local status_file="$1"
    xset s on && xset +dpms
    echo "<action=\`~/.xmonad/bin/toggle-screen-sleep-movie-mode-v2.sh\`><fc=${offColor}>Movie</fc></action>" > "${status_file}"    # Green highlight
}

toggle_moviemode() {
    local status_file="$1"
    local dpms_state="$2"

    if [[ "$dpms_state" == "Enabled" ]]; then # if movie mode = disable
      set_moviemode_on "$status_file"
    else
      set_moviemode_off "$status_file"
    fi
}

#toggle_moviemode "$status_file" "$dpms_state"
#set_moviemode_on "$status_file"

# Notify XMobar to refresh (if needed)
#pkill -SIGUSR1 xmobar
