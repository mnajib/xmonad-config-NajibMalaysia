#!/usr/bin/env bash
# ~/.xmonad/lib/trayer.sh
#
# Copyright (c) 2024 xmonad-config-NajibMalaysia
# Licensed under the BSD 3-Clause License. See LICENSE file for details.
#

trayerIsAlive_old(){
  local processName="trayer"

  processId =$(ps aux | grep $processName | grep -v grep| awk '{print $2}')
  if cat /proc/$processId/status | grep "State:  R (running)" > /dev/null
  then
    echo 0
  else
    echo 1
  fi

}

killTrayerIfAlive_old(){
  if $(pidof trayer); then
    pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
  fi
}

killTrayer_old(){
  pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
}

trayerIsAlive(){
  local processName="trayer"
  local processId

  processId=$(ps aux | grep "$processName" | grep -v grep | awk '{print $2}')
  if [ -n "$processId" ] && cat /proc/$processId/status 2>/dev/null | grep "State:\s*R (running)" > /dev/null; then
    echo 0
  else
    echo 1
  fi
}

killTrayerIfAlive(){
  if pgrep -x trayer > /dev/null; then
    pkill -x trayer
  fi
}

killTrayer(){
  pkill -x trayer
}

#
# Usage:
#   startTrayer <monitor_number>
#   startTrayer 0
#   startTrayer 1
#
# monitor numbered from left-to-right, start with monitor_number 0
startTrayer_old(){
  local monitorNumber
  monitorNumber=$1

  case $HOSTNAME in
    sakinah)
      trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand false --width 12 --transparent true --alpha 0 --tint 0xffffff  --height 16 --monitor $monitorNumber --padding 5 --margin 1 --distance 1 --iconspacing 4 
      ;;
    *)
      trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand false --width 16 --transparent true --alpha 0 --tint 0xffffff  --height 16 --monitor $monitorNumber --padding 5 --margin 1 --distance 1 --iconspacing 4 &
      ;;
  esac

}

#
# Usage:
#   startTrayer [--monitor 0] [--width 20] [--tint 0x333333] ...
#   Contoh override width sahaja tanpa kacau monitor:
#   startTrayer --width 24
#
startTrayer(){
  # 1. Tetapkan nilai lalai (Default Values)
  local monitorNumber="0"
  local edge="top"
  local align="right"
  local width="16"
  local height="16"
  local tint="0xffffff"
  local alpha="0"
  local padding="5"
  local margin="1"
  local distance="1"
  local iconspacing="4"
  local transparent="true"
  local setDockType="true"
  local setPartialStrut="true"
  local expand="false"

  # 2. Parse arguments menggunakan gelung (while-shift loop)
  while [[ "$#" -gt 0 ]]; do
    case $1 in
      --monitor) monitorNumber="$2"; shift ;;
      --edge) edge="$2"; shift ;;
      --align) align="$2"; shift ;;
      --width) width="$2"; shift ;;
      --height) height="$2"; shift ;;
      --tint) tint="$2"; shift ;;
      --alpha) alpha="$2"; shift ;;
      --padding) padding="$2"; shift ;;
      --margin) margin="$2"; shift ;;
      --distance) distance="$2"; shift ;;
      --iconspacing) iconspacing="$2"; shift ;;
      --transparent) transparent="$2"; shift ;;
      --setdocktype) setDockType="$2"; shift ;;
      --setpartialstrut) setPartialStrut="$2"; shift ;;
      --expand) expand="$2"; shift ;;
      *)
        echo "Unknown parameter: $1" >&2
        return 1
        ;;
    esac
    shift
  done

  # 3. Bunuh proses lama sebelum mula baru
  killTrayerIfAlive

  # 4. Jalankan trayer dengan nilai yang telah ditetapkan
  trayer \
    --edge "$edge" \
    --align "$align" \
    --SetDockType "$setDockType" \
    --SetPartialStrut "$setPartialStrut" \
    --expand "$expand" \
    --width "$width" \
    --transparent "$transparent" \
    --alpha "$alpha" \
    --tint "$tint" \
    --height "$height" \
    --monitor "$monitorNumber" \
    --padding "$padding" \
    --margin "$margin" \
    --distance "$distance" \
    --iconspacing "$iconspacing" &
}
