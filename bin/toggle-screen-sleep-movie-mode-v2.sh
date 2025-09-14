#!/usr/bin/env bash

status_file="/tmp/movie-mode-status"

# UP
FgColor1="#000000"  #"#181715"
#FgColor1="#ff0000" #"#181715"
BgColor1="#ff0000" #"#58C5F1"
# DOWN
FgColor2="#646464"
BgColor2="#ff0000"

onColor="${FgColor1},${BgColor1}"
#onColor="${FgColor1}"
#offColor="${FgColor2},${BgColor2}"
offColor="${FgColor2}"

dpms_state=$(xset q | grep "DPMS is" | awk '{print $3}')

if [[ "$dpms_state" == "Enabled" ]]; then
    xset s off && xset -dpms
    #echo "<fc=#ff0000>🎥 MOVIE MODE</fc>" > "$status_file"  # Red highlight
    #echo "<fc=#ff0000>Movie</fc>" > "$status_file"  # Red highlight
    #echo "<fc=${onColor}>Movie</fc>" > "$status_file"  # Red highlight
    echo "<action=\`~/.xmonad/bin/toggle-screen-sleep-movie-mode-v2.sh\`><fc=${onColor}>Movie</fc></action>" > "$status_file"  # Red highlight
else
    xset s on && xset +dpms
    #echo "<fc=#00ff00>🖥️ NORMAL</fc>" > "$status_file"    # Green highlight
    #echo "<fc=#00ff00>Movie</fc>" > "$status_file"    # Green highlight
    #echo "<fc=${offColor}>Movie</fc>" > "$status_file"    # Green highlight
    echo "<action=\`~/.xmonad/bin/toggle-screen-sleep-movie-mode-v2.sh\`><fc=${offColor}>Movie</fc></action>" > "$status_file"    # Green highlight
fi

# Notify XMobar to refresh (if needed)
#pkill -SIGUSR1 xmobar
