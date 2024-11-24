#!/usr/bin/env bash

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

$HOME/.xmonad/bin/set-display-screen-power-saver.sh
#xset -dpms                              # to disable DPMS
#xset s blank                            #
#xset s 300                              # screen will blank/power-off after 5-minutes session is in idle state
#xset +dpms                              # to enable DPMS
#xset dpms 300 300 300                   # for standby, suspend, and off
#xset dmps force off                    # there is normally no difference between the 'standby', 'suspend' and 'off' modes
#xset dmps force stanby                 #
#xset dmps force suspend                #
