#!/usr/bin/env bash

#
# Usage:
#   init-second-monitor1280x1024-forKeira.sh dual
#   init-second-monitor1280x1024-forKeira.sh single
#

export DISPLAY=:0
#export XAUTHORITY=/home/juliani/.Xauthority

#xrandr -q

internal=LVDS-1 # bottom, 1366x768 thinkpad x230
external=VGA-1  # top, thinkvision 1280x1024

#dmode="$(cat /sys/class/drm/card0-VGA-1/status)"

# set dual monitors
dual () {
  # ~/.screenlayout/khawlah1366x768_dualScreenWithThinkVision1280x1024.sh
  #xrandr --output VGA-0 --primary --left-of HDMI-0 --output HDMI-0 --auto
  #xrandr --output LVDS-1 --mode 1280x800 --primary --auto --output VGA-1 --mode 1280x1024 --left-of LVDS-1 --auto
  #xrandr --output $internal --mode 1280x800 --primary --auto --output $external --mode 1280x1024 --left-of $internal --auto
  #xrandr --output $internal --mode 1280x800 --primary --pos 1280x224 --output $external --mode 1280x1024 --pos 0x0
  #xrandr --output $internal --mode 1280x800 --primary --pos 1280x480 --output $external --mode 1280x1024 --pos 0x0
  xrandr --output $internal --mode 1366x768 --primary --pos 0x1024 --output $external --mode 1280x1024 --pos 184x0
}

# set single monitor
single () {
    #xrandr --output HDMI-0 --off
    #xrandr --output VGA-1 --off
    xrandr --output $external --off
}

#dual
