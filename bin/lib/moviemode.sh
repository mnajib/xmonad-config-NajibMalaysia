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

set_moviemode_off() {
    xset s off && xset -dpms
    echo "<action=\`~/.xmonad/bin/toggle-screen-sleep-movie-mode-v2.sh\`><fc=${onColor}>Movie</fc></action>" > "$status_file"  # Red highlight
}

set_moviemode_on() {
    local status_file="$1"
    xset s on && xset +dpms
    echo "<action=\`~/.xmonad/bin/toggle-screen-sleep-movie-mode-v2.sh\`><fc=${offColor}>Movie</fc></action>" > "${status_file}"    # Green highlight
}

toggle_moviemode() {
    local status_file="$1"
    local dpms_state="$2"

    if [[ "$dpms_state" == "Enabled" ]]; then
      set_moviemode_off "$status_file"
    else
      set_moviemode_on "$status_file"
    fi
}

#toggle_moviemode "$status_file" "$dpms_state"
#set_moviemode_on "$status_file"

# Notify XMobar to refresh (if needed)
#pkill -SIGUSR1 xmobar
