#!/usr/bin/env bash

printUsage () {
  echo "Usage:"
  echo "  $0 dual"
  echo "  $0 single"
}

export DISPLAY=:0
#export XAUTHORITY=/home/juliani/.Xauthority

internal=LVDS-1 # right
intRes="1600x900"
external=VGA-1  # left
extRes="1024x768"

#dmode="$(cat /sys/class/drm/card0-VGA-1/status)"

# set dual monitors
dual () {
    echo "Activating dual mode ..."

    xrandr --output $internal --mode $intRes --primary --pos 1024x130 --rotate normal \
           --output $external --mode $extRes --pos 0x0 --rotate normal \
           --output HDMI-1 --off \
           --output HDMI-2 --off \
           --output HDMI-3 --off \
           --output DP-1 --off \
           --output DP-2 --off \
           --output DP-3 --off
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
