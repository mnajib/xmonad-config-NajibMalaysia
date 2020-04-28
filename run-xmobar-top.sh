#!/run/current-system/sw/bin/env bash

mkfifo /tmp/najib-wsp.log
mkfifo /tmp/najib-zikirpipe

#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x191970 --height 12 &
#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x181715 --height 12 --alpha 0 &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 15 --transparent true --tint 0xeaeaea --height 14 --alpha 0 &

~/.xmonad/zikir &

xmobar ~/.xmonad/xmobarrc-top.hs &
