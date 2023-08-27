#!/usr/bin/env bash

printUsage () {
  echo "Usage:"
  echo "  $0 dual"
  echo "  $0 single"
}

export DISPLAY=:0
#export XAUTHORITY=/home/juliani/.Xauthority

internal=LVDS-1 # right
external=VGA-1  # left

#dmode="$(cat /sys/class/drm/card0-VGA-1/status)"

# set dual monitors
dual () {
    echo "Activating dual mode ..."

    #cvt -r 1280 1024 60
    #xrandr --newmode "1280x1024"  90.75  1280 1328 1360 1440  1024 1027 1034 1054 +hsync -vsync
    #xrandr --addmode $external "1280x1024"

    #xrandr --output $internal --mode 1280x800 --primary --pos 1280x327 --rotate normal \
    #       --output $external --mode 1280x1024 --pos 0x0 --rotate normal \
    #       --output DP-1 --off \
    #       --output DP-2 --off \
    #       --output DP-3 --off

    xrandr  --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
            --output VGA-1 --mode 1280x1024 --pos 1920x0 --rotate normal \
            --output DP-1 --off \
            --output HDMI-1 --off \
            --output DP-1-2 --off \
            --output DP-1-3 --mode 1280x1024 --pos 3200x0 --rotate normal \
            --output DP-1-4 --off
}

# set single monitor
single () {
    echo "Activating single mode ..."

    #xrandr --output HDMI-0 --off
    #xrandr --output VGA-1 --off
    xrandr --output $external --off
}

case $1 in
  dual)
    dual
    ;;
  single)
    single
    ;;
  *)
    printUsage
    ;;
esac
