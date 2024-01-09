#!/usr/bin/env bash

echo "XXX: test test test"

echo $DISPLAY
#export DISPLAY=":0"
#umask 0002

# Recompile xmonad
#xmonad --recompile

# Reset the log file
cat /dev/null > /tmp/${USER}-wsp.log

# If not already created
#rm -f /tmp/${USER}-zikirpipe # xmobar need this file before xmobar start
if [ ! -f /tmp/${USER}-zikirpipe ]; then
  #echo "File does not exist"
  mkfifo /tmp/${USER}-zikirpipe
fi

# Killing
#ps auxwww | egrep -i "zikir|xmobar|solat|trayer|LED|pasystray|volumeicon"
#~/.xmonad/bin/list-running-process.sh
#killall -9 trayer
#killall -9 zikir
#killall -9 pasystray
#killall -9 volumeicon
#~/.xmonad/bin/kill2restart.sh
#~/.xmonad/bin/kill2restartSidetool.sh
#sleep 1

# Starting

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

startTrayer(){
  trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 & # laptop as 1'sf monitor positioned from left-to-right
}

case $HOSTNAME in
  keira)
    echo "keira"
    # dual monitor, external-monitor on the left (keira)
    #~/bin/init-second-monitor1280x1024-forKeira.sh dual
    #$HOME/bin/init-second-monitor1280x1024-forKeira.sh dual
    #$HOME/.xmonad/bin/init-second-monitor1280x1024-forKeira.sh dual
    $HOME/.xmonad/bin/keira-dual-screen-dell-monitor.sh dual
    sleep 5
    pkill trayer
    sleep 5
    pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
    sleep 5 # 1
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &
    setxkbmap us # Not sure if I really need this, but just a safe bet tu make sure user not freakout if somehow the keyboard layout not US right after login.
    #setxkbmap us dvorak
    ;;
  #zahrahDISABLEXXX)
  zahrah)
    echo "zahrah"
    #$HOME/bin/init-second-monitor1280x1024-forZahrah.sh dual
    #$HOME/.xmonad/bin/init-secondMonitorPhilips1280x1024-forZahrah.sh dual
    #$HOME/.xmonad/bin/zahrah-dual-screen-philips-monitor.sh dual
    #sleep 5
    #pkill trayer
    #sleep 5
    #pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
    #sleep 5 # 1
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 0 &
    #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &
    setxkbmap dvorak
    ;;
  raudah)
    echo "raudah"
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 0 &
    #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &
    setxkbmap dvorak
    ;;
  sakinah)
    echo "sakinah"
    #$HOME/bin/sakinah-dual-screen-with-dell-monitor.sh
    $HOME/.xmonad/bin/sakinah-dual-screen-with-dell-monitor.sh dual
    setxkbmap dvorak
    sleep 5
    pkill trayer
    sleep 5
    pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
    sleep 5 # 1
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &
    ;;
  asmak|naqib)
    echo "asmak"
    #$HOME/.xmonad/bin/asmak-dual-screen-with-thinkvision-monitor.sh dual
    $HOME/.xmonad/bin/asmak-dualMonitor-ThinkpadT430s_1600x900-ThinkVision1280x1024.sh
    setxkbmap dvorak
    sleep 5
    pkill trayer
    sleep 5
    pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
    sleep 5 # 1
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &
    ;;
  delldesktop)
    echo "delldesktop"
    #$HOME/.xmonad/bin/delldesktop-dualMonitor-ThinkVision1280x1024-PanasonicTV1920x1080.sh
    setxkbmap dvorak
    sleep 5
    pkill trayer
    sleep 5
    pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
    sleep 5 # 1
    #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 0 &
    #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &
    trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &
    ;;
  khadijah)
    echo "khadijah"
    #$HOME/.xmonad/bin/delldesktop-dualMonitor-ThinkVision1280x1024-PanasonicTV1920x1080.sh
    #setxkbmap dvorak
    #sleep 5
    #pkill trayer
    #sleep 5
    #pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
    #sleep 5 # 1
    #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 0 & # laptop as 1'sf monitor positioned from left-to-right
    #trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 0 & # laptop as 1'sf monitor positioned from left-to-right
    if [ ! trayerIsAlive ]; then
      trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 & # laptop as 1'sf monitor positioned from left-to-right
    fi
    #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &
    #trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 & # laptop as 2'nd monitor positioned from left-to-right
    #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --transparent true --tint 0xffffff --height 14 --width 12 --distance 1 --margin 1 --alpha 0 --monitor 0
    ;;
  manggis)
    echo "maggis"
    #sudo $HOME/bin/decrease-trackpoint-sensitivity-x220.sh
    sudo $HOME/.xmonad/bin/decrease-trackpoint-sensitivity-x220.sh
    setxkbmap us
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 &
    ;;
  khawlah)
    echo "khawlah"

    #$HOME/.xmonad/bin/init-secondMonitorThinkVision1280x1024-forkhawlah.sh dual
    #xrandr --output LVDS-1 --off --output VGA-1 --primary --mode 1280x1024 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output HDMI-2 --off --output HDMI-3 --off --output DP-2 --off --output DP-3 --off
    #$HOME/.xmonad/bin/khawlah-dualMonitor-Thinkpadx230_1366x768_and_LenovoThinkVision1280x1024.sh externalonly
    $HOME/.xmonad/bin/khawlah-dualMonitor-Thinkpadx230_1366x768_and_LenovoThinkVision1280x1024.sh

    sleep 5
    pkill trayer
    sleep 5
    pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
    sleep 5 # 1

    # top-right on laptop monitor
    #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &

    # top-fullexpand on ThinkVision monitor
    #trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 0 --iconspacing 2 &

    # top-right on ThinkVision monitor as the only monitor (with build-in Thinkpad-X230 monitor disabled)
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 0 --iconspacing 2 &

    setxkbmap dvorak
    ;;
  *)
    echo "lain"
    setxkbmap dvorak
    # single monitor
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 &
    ;;
esac

#sleep 1
~/.xmonad/bin/zikir &
sleep 1
volumeicon &
#pasystray &
#~/.fehbg &
fbsetroot -solid black &
nm-applet & # Not really needed, just use nmtui.

#xmobar ~/.xmonad/xmobarrc-top.hs &
#xmobar ~/.xmonad/xmobarrc.hs &

#qtox &
#xscreensaver -no-splash &

