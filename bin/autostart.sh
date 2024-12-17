#!/usr/bin/env bash

# Copyright (c) 2024 xmonad-config-NajibMalaysia
# Licensed under the BSD 3-Clause License. See LICENSE file for details.

#xscreensaver --no-splash &

case $HOSTNAME in
  keira)
    echo "Running some customization for $HOSTNAME"
    $HOME/.xmonad/bin/screenlayout-keira.sh
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
    sleep 1
    setxkbmap dvorak
    ;;
  # NOTE:
  #   DELL monitor, DVI port  <---------------->  DELL Precision M4800, DisplayPort
  #   Both of this device fail to detech each other.
  #   The monitor not detect the laptop, and quickly will sleep in only a couple of seconds.
  #   The laptop (include ~/.xmonad/bin/screenlayout-khadijah.sh) not detech the monitor because the monitor in sleeping while the laptop/script try to detecting.
  #   Need to make it detect both each other in the same time.
  #   Try use this to monitor when the laptop detect the monitor:
  #     while true; do xrandr  | grep -C 3 'DP-'; sleep 2; clear; done
  #   and while the laptop it still detected the monitor, run the script (~/.xmonad/bin/screenlayout-khadijah.sh).
  khadijah)
    echo "Running some customization for $HOSTNAME"

    $HOME/.xmonad/bin/screenlayout-khadijah.sh
    sleep 1

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

$HOME/.xmonad/bin/set-display-screen-power-saver.sh
#xset -dpms                              # to disable DPMS
#xset s blank                            #
#xset s 300                              # screen will blank/power-off after 5-minutes session is in idle state
#xset +dpms                              # to enable DPMS
#xset dpms 300 300 300                   # for standby, suspend, and off
#xset dmps force off                    # there is normally no difference between the 'standby', 'suspend' and 'off' modes
#xset dmps force stanby                 #
#xset dmps force suspend                #
