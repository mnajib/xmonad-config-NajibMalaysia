#!/usr/bin/env bash

xscreensaver --no-splash &

case $HOSTNAME in
  keira)
    echo "Running some customization for $HOSTNAME"

    # If VGA-1 connected, do
    # setting for dual monitor
    $HOME/.xmonad/bin/keira-dual-screen-dell-monitor.sh dual
    # else do
    # setting for single monitor
    # ...

    setxkbmap us
    ;;
  zahrah)
    echo "Running some customization for $HOSTNAME"
    #$HOME/.xmonad/bin/init-secondMonitorPhilips1280x1024-forZahrah.sh dual
    $HOME/.xmonad/bin/zahrah-dual-screen-philips-monitor.sh dual
    sleep 1
    setxkbmap dvorak
    ;;
  sakinah)
    echo "Running some customization for $HOSTNAME"
    $HOME/.xmonad/bin/sakinah-dual-screen-dell-monitor.sh dual
    setxkbmap dvorak
    ;;
  *)
    echo "Else .."
    ;;
esac
