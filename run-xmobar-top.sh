#!/run/current-system/sw/bin/env bash

#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x191970 --height 12 &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x181715 --height 12 --alpha 0 &

xmobar ~/.xmonad/xmobarrc-top.hs &
