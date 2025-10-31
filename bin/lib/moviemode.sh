#!/usr/bin/env bash

status_file="/tmp/${USER}-movie-mode-status"

# UP
FgColor1="#000000"  #"#181715"
BgColor1="#ff0000" #"#58C5F1"
# DOWN
FgColor2="#646464"
BgColor2="#ff0000"

onColor="${FgColor1},${BgColor1}"
offColor="${FgColor2}"

#dpms_state=$(xset q | grep "DPMS is" | awk '{print $3}')

toggle_moviemode() {
    local status_file="$1"
    local dpms_state="$2"

    if [[ "$dpms_state" == "Enabled" ]]; then
      set_moviemode_off "$status_file"
    else
      set_moviemode_of "$status_file"
    fi
}

set_moviemode_off() {
    xset s off && xset -dpms
    echo "<fc=${onColor}>Movie</fc>" > "$status_file"  # Red highlight
}

set_moviemode_on() {
    local status_file="$1"
    xset s on && xset +dpms
    echo "<action=\`~/.xmonad/bin/toggle-screen-sleep-movie-mode-v2.sh\`><fc=${offColor}>Movie</fc></action>" > "${status_file}"    # Green highlight
}

#toggle_moviemode "$status_file" "$dpms_state"
#set_moviemode_on "$status_file"

# Notify XMobar to refresh (if needed)
#pkill -SIGUSR1 xmobar
