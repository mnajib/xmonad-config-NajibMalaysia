#!/usr/bin/env bash

export DISPLAY=:0
#umask 0002

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

#case $HOSTNAME in
#    (keira)
#        ...
#        ...
#        ;;
#    (mahirah)
#        ...
#        ;;
#    (*)
#        ...
#        ...
#        ;;
#esac
if [ "$HOSTNAME" = keira ]; then
    # dual monitor, external-monitor on the left (keira)

    ~/bin/init-second-monitor-ThinkVisionForKeira.sh

    sleep 5
    pkill trayer
    sleep 5
    pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
    sleep 5 # 1
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 --monitor 1 &

    #setxkbmap us
    #setxkbmap us dvorak
elif [ "$HOSTNAME" = manggis ]; then
    sudo $HOME/bin/decrease-trackpoint-sensitivity-x220.sh
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 &
else
    # single monitor
    trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 12 --transparent true --tint 0xffffff --height 14 --alpha 0 &
fi

sleep 1
~/.xmonad/bin/zikir &
volumeicon &
#pasystray &
#~/.fehbg &
fbsetroot -solid black &
nm-applet & # Not really needed, just use nmtui.

#xmobar ~/.xmonad/xmobarrc-top.hs &
#xmobar ~/.xmonad/xmobarrc.hs &

#qtox &
#xscreensaver -no-splash &

