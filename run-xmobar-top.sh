#!/run/current-system/sw/bin/env bash

#mkfifo /tmp/najib-wsp.log
# Reset the log file
cat /dev/null > /tmp/najib-wsp.log

mkfifo /tmp/najib-zikirpipe

ps auxwww | egrep -i "zikir|xmobar|solat|trayer"
killall -9 trayer
killall -9 zikir
killall -9 pasystray

#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x191970 --height 12 &
#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x181715 --height 12 --alpha 0 &
#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 15 --transparent true --tint 0x555555 --height 14 --alpha 0 &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0x555555 --height 14 --alpha 0 &

~/.xmonad/zikir &
pasystray &
~/.fehbg &
xmobar ~/.xmonad/xmobarrc-top.hs &
