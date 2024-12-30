#!/usr/bin/env bash

# Copyright (c) 2024 xmonad-config-NajibMalaysia
# Licensed under the BSD 3-Clause License. See LICENSE file for details.


# --------------------------------------------------------------------------------------------------
# Reset the log file
# --------------------------------------------------------------------------------------------------
#LOGFILE1="/tmp/${USER}-zikirlog"
#cat /dev/null > ""$LOGFILE1""
#echo "`date` ${HOME}/.xmonad/bin/start-sidetool.sh: reset this log file" >> "${LOGFILE1}"
#
LOGFILE2="/tmp/${USER}-wsp.log"
cat /dev/null > "$LOGFILE2"
echo "`date` ${HOME}/.xmonad/bin/start-sidetool.sh: reset this log file" >> "$LOGFILE2"
#
cat /dev/null > /tmp/${USER}-prayer_reminder_log
echo "`date` ${HOME}/.xmonad/bin/start-sidetool.sh: reset this log file" >> "/tmp/${USER}-prayer_reminder_log"
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
# Start zikir
# --------------------------------------------------------------------------------------------------
## If not already created, xmobar need this file before xmobar start
#if [ ! -f /tmp/${USER}-zikirpipe ]; then
#  mkfifo /tmp/${USER}-zikirpipe
#fi
#sleep 1
#~/.xmonad/bin/zikir &
#
# --------------------------------------------------------------------------------------------------
# Start waktu solat
# --------------------------------------------------------------------------------------------------
#~/.xmonad/bin/waktusolat-hbar SGR01 &
#
# --------------------------------------------------------------------------------------------------
# Start waktu solat reminder
# --------------------------------------------------------------------------------------------------
#sleep 1
#~/.xmonad/bin/reminder.sh &
sleep 1
# --------------------------------------------------------------------------------------------------


trayerIsAlive(){
  local processName="trayer"

  #ps auxwww | grep -i trayer
  #ps aux | grep -i trayer | grep -v grep

  processId =$(ps aux | grep $processName | grep -v grep| awk '{print $2}')
  #if cat /proc/$processId/status | grep "State:  R (running)" > /dev/null
  if cat /proc/$processId/status | grep "State:  R (running)" > /dev/null
  then
    #echo "Running"
    # return 0 for running
    echo 0
  else
    #echo "Not running"
    # return 1 for "Not running"
    echo 1
  fi

}

killTrayerIfAlive(){
  if $(pidof trayer); then
    pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
  fi
}

killTrayer(){
  #if $(pidof trayer); then
    pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
  #fi
  #pidof trayer
  #kill(pid,0)
  #killall -s 0 trayer
  #cat /proc/${pid}/status
}

#
# Usage:
#   startTrayer <monitor_number>
#   startTrayer 0
#   startTrayer 1
#
# monitor numbered from left-to-right, start with monitor_number 0
startTrayer(){
  local monitorNumber
  monitorNumber=$1

  #if [ ! trayerIsAlive ]; then
  #trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 &
  #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor $monitorNumber &
  trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor $monitorNumber &
  #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor $monitorNumber -l &
  #fi
}

case $HOSTNAME in
  keira)
    echo "keira"
    setxkbmap us # Not sure if I really need this, but just a safe bet tu make sure user not freakout if somehow the keyboard layout not US right after login.
    startTrayer 0
    ;;
  #zahrahDISABLEXXX)
  zahrah)
    echo "zahrah"
    startTrayer 1
    setxkbmap dvorak
    #$HOME/bin/kill-program barrier
    #sleep 2
    #$HOME/bin/barrier-launcher.sh start server --server zahrah --config-file ~/.config/barrier/barrier.conf &
    ;;
  raudah)
    echo "raudah"
    startTrayer 0
    setxkbmap dvorak
    ;;
  sakinah)
    echo "sakinah"
    setxkbmap dvorak
    startTrayer 1
    ;;
  asmak|naqib)
    echo "asmak"
    setxkbmap dvorak
    startTrayer 1
    ;;
  delldesktop)
    echo "delldesktop"
    setxkbmap dvorak
    startTrayer 1
    ;;
  khadijah)
    echo "khadijah"
    #trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 & # laptop as 1'sf monitor positioned from left-to-right
    #startTrayer 0
    startTrayer 2
    #$HOME/bin/kill-program barrier
    #sleep 2
    #$HOME/bin/barrier-launcher.sh start client --client khadijah --server zahrah &
    ;;
  taufiq)
    echo "taufiq"
    setxkbmap dvorak
    startTrayer 0
    #$HOME/bin/kill-program barrier
    #sleep 2
    #$HOME/bin/barrier-launcher.sh start client --client taufiq --server zahrah &
    ;;
  manggis)
    echo "maggis"
    #sudo $HOME/bin/decrease-trackpoint-sensitivity-x220.sh
    sudo $HOME/.xmonad/bin/decrease-trackpoint-sensitivity-x220.sh
    setxkbmap us
    startTrayer 0
    ;;
  khawlah)
    echo "khawlah"

    #$HOME/.xmonad/bin/init-secondMonitorThinkVision1280x1024-forkhawlah.sh dual
    #xrandr --output LVDS-1 --off --output VGA-1 --primary --mode 1280x1024 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output HDMI-3 --off --output DP-2 --off --output DP-3 --off
    #$HOME/.xmonad/bin/khawlah-dualMonitor-Thinkpadx230_1366x768_and_LenovoThinkVision1280x1024.sh externalonly
    $HOME/.xmonad/bin/khawlah-dualMonitor-Thinkpadx230_1366x768_and_LenovoThinkVision1280x1024.sh

    startTrayer 0
    setxkbmap dvorak
    ;;
  *)
    echo "lain"
    setxkbmap dvorak
    startTrayer 0
    ;;
esac

sleep 2

# Volume Control
volumeicon &
#pasystray &

# Set wallpaper
#~/.fehbg &
fbsetroot -solid black &

# Newwork Manager
nm-applet & # Not really needed, just use nmtui.

#xmobar ~/.xmonad/xmobarrc-top.hs &
#xmobar ~/.xmonad/xmobarrc.hs &

#qtox &

$HOME/.xmonad/bin/waktusolat-hbar SGR01 &

#xscreensaver -no-splash &
$HOME/.xmonad/bin/set-display-screen-power-saver.sh
