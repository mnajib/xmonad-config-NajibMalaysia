#!/usr/bin/env bash

# Copyright (c) 2024 xmonad-config-NajibMalaysia
# Licensed under the BSD 3-Clause License. See LICENSE file for details.

#xscreensaver --no-splash &

#
# NOTE:
#   DELL monitor, DVI port  <---------------->  DELL Precision M4800, DisplayPort
#   Both of this device fail to detech each other.
#   The monitor not detect the laptop, and quickly will sleep in only a couple of seconds.
#   The laptop (include ~/.xmonad/bin/screenlayout-khadijah.sh) not detech the monitor because the monitor in sleeping while the laptop/script try to detecting.
#   Need to make it detect both each other in the same time.
#   Try use this to monitor when the laptop detect the monitor:
#     while true; do xrandr  | grep -C 3 'DP-'; sleep 2; clear; done
#   and while the laptop it still detected the monitor, run the script (~/.xmonad/bin/screenlayout-khadijah.sh).
#


#----------------------------------------------------------------
# NOTE:
#
#xrandr --verbose | less
#
#xrandr --listmonitors
#Monitors: 3
# 0: +*VGA-1-1 1280/376x1024/301+1920+0  VGA-1-1
# 1: +DP-1 1280/376x1024/301+3200+0  DP-1
# 2: +eDP-1-1 1920/344x1080/194+0+0  eDP-1-1
#
#xrandr --setmonitor CombineMonitor 2560/752x1024/301+1920+0 VGA-1-1,DP-1
#xrandr --setmonitor LaptopMonitor 1920/344x1080/194+0+0 eDP-1-1
#
#xrandr --listmonitors
#Monitors: 2
# 0: CombineMonitor 2560/752x1024/301+0+0  VGA-1-1 DP-1
# 1: LaptopMonitor 1920/344x1080/194+0+0  eDP-1-1
#----------------------------------------------------------------


# Define Defaults
LAYOUT_DIR="${HOME}/.xmonad/bin"
DEFAULT_LAYOUT="us"

# Host-Specific Keyboard Layout Overrides
# Only map hosts here if they deviate from your default Dvorak layout
case "${HOSTNAME}" in
  keira)
    KEYBOARD_LAYOUT="us"
    ;;
  *)
    KEYBOARD_LAYOUT="dvorak"
    ;;
esac

echo "Applying environment configuration for host: ${HOSTNAME}"

# Dynamic Screen Layout Resolution
# Instead of hardcoding paths per machine, dynamically check if a layout file exists
SCREEN_SCRIPT="${LAYOUT_DIR}/screenlayout-${HOSTNAME}.sh"

if [[ -f "${SCREEN_SCRIPT}" ]]; then
    echo "Found custom monitor profile: ${SCREEN_SCRIPT}"
    "${SCREEN_SCRIPT}"
    sleep 1 # Hardware synchronization buffer
else
    # Explicit mapping fallbacks for systems that share layouts
    case "${HOSTNAME}" in
      asmak|naqib)
        SHARED_SCRIPT="${LAYOUT_DIR}/screenlayout-asmak.sh"
        if [[ -f "${SHARED_SCRIPT}" ]]; then
            "${SHARED_SCRIPT}"
            sleep 1
        fi
        ;;
      *)
        echo "No host-specific screen layout file detected. Skipping xrandr changes."
        ;;
    esac
fi

# 4. Apply Final Keyboard Configuration
echo "Setting system keymap mapping to: ${KEYBOARD_LAYOUT}"
setxkbmap "${KEYBOARD_LAYOUT}"

# Background / System Services (Uncomment when needed)
# xscreensaver --no-splash &


#$HOME/.xmonad/bin/kill2restart.sh
#$HOME/.xmonad/bin/kill2restartSidetool.sh
#sleep 3
#$HOME/.xmonad/bin/restart-xmobar-sidetool.sh

$HOME/.xmonad/bin/set-display-screen-power-saver.sh
#xset -dpms                              # to disable DPMS
#xset s blank                            #
#xset s 300                              # screen will blank/power-off after 5-minutes session is in idle state
#xset +dpms                              # to enable DPMS
#xset dpms 300 300 300                   # for standby, suspend, and off
#xset dmps force off                    # there is normally no difference between the 'standby', 'suspend' and 'off' modes
#xset dmps force stanby                 #
#xset dmps force suspend                #
