#!/usr/bin/env bash

# Copyright (c) 2024 xmonad-config-NajibMalaysia
# Licensed under the BSD 3-Clause License. See LICENSE file for details.


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

  #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor $monitorNumber &
  #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand false --width 16 --transparent true --tint 0x333333 --height 16 --alpha 200 --monitor $monitorNumber --padding 5 &
  #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand false --width 16 --transparent true --tint 0x333333 --height 16 --alpha 200 --monitor $monitorNumber --padding 5 --margin 1 --distance 1 --iconspacing 4 &

  #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand false --width 16 --transparent false --tint 0x333333 --height 16 --monitor $monitorNumber --padding 5 --margin 1 --distance 1 --iconspacing 4 &
  trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand false --width 16 --transparent true --alpha 0 --tint 0xffffff  --height 16 --monitor $monitorNumber --padding 5 --margin 1 --distance 1 --iconspacing 4 &

  #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor $monitorNumber -l &
  #fi
}

