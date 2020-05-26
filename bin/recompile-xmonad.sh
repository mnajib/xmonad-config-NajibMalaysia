#!/run/current-system/sw/bin/env bash

# Recompile xmonad
xmonad --recompile

# Reset the log file
cat /dev/null > /tmp/najib-wsp.log

# If not already created
mkfifo /tmp/najib-zikirpipe

# Killing
#ps auxwww | egrep -i "zikir|xmobar|solat|trayer|LED|pasystray|volumeicon"
#~/.xmonad/bin/list-running-process.sh
#killall -9 trayer
#killall -9 zikir
#killall -9 pasystray
#killall -9 volumeicon
~/.xmonad/bin/kill2restart.sh

# Starting
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 &
~/.xmonad/bin/zikir &
volumeicon &
#pasystray &
~/.fehbg &
nm-applet &
#xmobar ~/.xmonad/xmobarrc-top.hs &

# Restart xmonad
xmonad --restart
