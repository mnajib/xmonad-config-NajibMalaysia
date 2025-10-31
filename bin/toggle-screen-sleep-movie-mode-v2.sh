#!/usr/bin/env bash

source "${HOME}/.xmonad/bin/lib/moviemode.sh"

dpms_state=$(xset q | grep "DPMS is" | awk '{print $3}')

toggle_moviemode "$status_file" "$dpms_state"

# Notify XMobar to refresh (if needed)
#pkill -SIGUSR1 xmobar
