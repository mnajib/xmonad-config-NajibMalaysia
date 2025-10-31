#!/usr/bin/env bash

#ps auxwww | egrep -i "zikir|xmobar|solat|trayer|LED|pasystray|volumeicon"
#~/.xmonad/bin/list-running-process.sh
#echo "--------------------"


killall -9 trayer
killall -9 zikir
killall -9 pasystray
killall -9 volumeicon

pgrep -a bash | grep 'waktusolat-hbar' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep '.xmonad/bin/keyboard-LED-status.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep '/zikir' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a pasystray | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a volumeicon | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a nm-applet | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
#pgrep -a qtox | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'netconnstatus.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'NetConnStatus' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a xscreensaver | grep 'xscreensaver' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a zikir | grep 'xscreensaver' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill

pgrep -a bash | grep 'waktusolat-hbar' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'reminder.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'loop-cat-prayer_reminder_file.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill

pgrep -a bash | grep 'get-movie-mode-status.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill

sleep 2
#echo "--------------------"
#ps auxwww | egrep -i "zikir|xmobar|solat|trayer|LED|pasystray|volumeicon"
#~/.xmonad/bin/list-running-process.sh
