#!/usr/bin/env bash

export DISPLAY=:0

# Recompile xmonad
#xmonad --recompile

# Reset the log file
cat /dev/null > /tmp/${USER}-wsp.log

# If not already created
rm -f /tmp/${USER}-zikirpipe
mkfifo /tmp/${USER}-zikirpipe

# Killing
#ps auxwww | egrep -i "zikir|xmobar|solat|trayer|LED|pasystray|volumeicon"
#~/.xmonad/bin/list-running-process.sh
#killall -9 trayer
#killall -9 zikir
#killall -9 pasystray
#killall -9 volumeicon
~/.xmonad/bin/kill2restart.sh
sleep 1

# Starting

# single monitor
#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width request --transparent true --tint 0xffffff --height 14 --alpha 0 &
sleep 2
#
# dual monitor
#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &

~/.xmonad/bin/zikir &
volumeicon &
#pasystray &
#~/.fehbg &
fbsetroot -solid black &
nm-applet & # Not really needed, just use nmtui.
#xmobar ~/.xmonad/xmobarrc-top.hs &
#qtox &
#xscreensaver -no-splash &

# Restart xmonad
xmonad --restart
