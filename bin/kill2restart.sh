#!/usr/bin/env bash
# ~/.xmonad/bin/kill2restart.sh

#killall -9 pasystray
#killall -9 trayer
#killall -9 volumeicon
#killall -9 xmobar
#killall -9 zikir
#killall -9 waktusolat-generator.sh
#killall -9 waktusolat-display.sh

pgrep -a bash | grep 'get-movie-mode-status.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'loop-cat-prayer_reminder_file.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'NetConnStatus' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'netconnstatus.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'reminder.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'waktusolat' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'waktusolat-hbar' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep '.xmonad/bin/keyboard-LED-status.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep '/zikir' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a nm-applet | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a pasystray | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a trayer | grep 'trayer --edge top --align right' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a volumeicon | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a xmobar | grep 'xmobar /home' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a xscreensaver | grep 'xscreensaver' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a zikir | grep 'xscreensaver' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill

#pkill -f waktusolat
#pkill -f reminder.sh
#pkill -f netconnstatus.sh
#pkill -f NetConnStatus
#pkill -f loop-cat-prayer_reminder_file.sh
#pkill -f xscreensaver
#pkill -f waktusolat-generator.sh
#pkill -f waktusolat-display.sh
#pkill -f pasystray
#pkill -f volumeicon
#pkill -f zikir
#pkill -f nm-applet
#pkill -f keyboard-LED-status.sh
#pkill -f trayer
#pkill -f xmobar
#pkill -f xmobar

#ps auxwww | egrep -i "zikir|xmobar|solat|trayer|LED|pasystray|volumeicon"

sleep 2
