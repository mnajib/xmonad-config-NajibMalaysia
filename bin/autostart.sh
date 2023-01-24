#!/usr/bin/env bash

xscreensaver --no-splash &

case $HOSTNAME in
  keira)
    echo "Running some customization for $HOSTNAME"

    # If VGA-1 connected, do
    # setting for dual monitor
    $HOME/bin/keira-dual-screen-dell-monitor.sh dual
    # else do
    # setting for single monitor
    # ...

    setxkbmap us
    ;;
  zahrah)
    echo "Running some customization for $HOSTNAME"
    setxkbmap dvorak
    ;;
  sakinah)
    echo "Running some customization for $HOSTNAME"
    ;;
  *)
    echo "Else .."
    ;;
esac
