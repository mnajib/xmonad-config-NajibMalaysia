#!/usr/bin/env bash

#xscreensaver --no-splash &

case $HOSTNAME in
  keira)
    echo "Running some customization for $HOSTNAME"
    $HOME/.xmonad/bin/screenlayout-khadijah.sh
    sleep 1
    setxkbmap us
    ;;
  zahrah)
    echo "Running some customization for $HOSTNAME"
    $HOME/.xmonad/bin/screenlayout-zahrah.sh
    sleep 1
    setxkbmap dvorak
    ;;
  khawlah)
    echo "Running some customization for $HOSTNAME"
    $HOME/.xmonad/bin/screenlayout-khawlah.sh
    sleep 1
    setxkbmap dvorak
    ;;
  sakinah)
    echo "Running some customization for $HOSTNAME"
    #$HOME/.xmonad/bin/sakinah-dual-screen-dell-monitor.sh dual
    sleep 1
    setxkbmap dvorak
    ;;
  asmak|naqib)
    echo "Running some customization for $HOSTNAME"
    $HOME/.xmonad/bin/screenlayout-asmak.sh
    sleep 1
    setxkbmap dvorak
    ;;
  raudah)
    echo "Running some customization for $HOSTNAME"
    $HOME/.xmonad/bin/screenlayout-raudah.sh
    sleep 1
    setxkbmap dvorak
    ;;
  delldesktop)
    echo "Running some customization for $HOSTNAME"
    #$HOME/.xmonad/bin/delldesktop-dualMonitor-ThinkVision1280x1024-PanasonicTV1920x1080.sh
    sleep 1
    setxkbmap dvorak
    ;;
  khadijah)
    echo "Running some customization for $HOSTNAME"
    $HOME/.xmonad/bin/screenlayout-khadijah.sh
    sleep 1
    setxkbmap dvorak
    ;;
  *)
    echo "Else .."
    ;;
esac

#$HOME/.xmonad/bin/kill2restart.sh
#$HOME/.xmonad/bin/kill2restartSidetool.sh
#sleep 3
#$HOME/.xmonad/bin/restart-xmobar-sidetool.sh

xset -dpms
xset s blank
xset s 300  # screen will blank/power-off after 5-minutes session is in idle state
