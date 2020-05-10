#!/run/current-system/sw/bin/env bash

#mkfifo /tmp/najib-wsp.log
# Reset the log file
cat /dev/null > /tmp/najib-wsp.log

mkfifo /tmp/najib-zikirpipe

ps auxwww | egrep -i "zikir|xmobar|solat|trayer|LED"
killall -9 trayer
killall -9 zikir
killall -9 pasystray
killall -9 volumeicon

trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 &

~/.xmonad/bin/zikir &
volumeicon &
#pasystray &
~/.fehbg &
xmobar ~/.xmonad/xmobarrc-top.hs &
