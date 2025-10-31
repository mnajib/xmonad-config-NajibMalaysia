#!/usr/bin/env bash

source "${HOME}/.xmonad/bin/lib/moviemode.sh"

set_moviemode_on "$status_file"
sleep 1
set_moviemode_off "$status_file"

# Notify XMobar to refresh (if needed)
#pkill -SIGUSR1 xmobar
