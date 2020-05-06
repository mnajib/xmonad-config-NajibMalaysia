#!/run/current-system/sw/bin/env bash

ps auxwww | egrep -i "zikir|xmobar|solat|trayer|LED"
echo "--------------------"

# xmobar
killall xmobar

# waktusolat-putrayaja-hbar-v2
#pids=`pgrep -a bash | grep 'bash /home/najib/.xmonad/waktusolat-putrajaya-hbar-v2' | awk '{print $1}'`
#pids=`pgrep -a bash | grep 'bash /home/najib/.xmonad/waktusolat-putrajaya-hbar-v2' | awk '{print $1}'| tr '\n' ' ' | sed 's/$/\n/'`
#while $pids; do
#kill $pids
#done
pgrep -a bash | grep 'bash /home/najib/.xmonad/waktusolat-putrajaya-hbar-v2' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
pgrep -a bash | grep 'bash /home/najib/.xmonad/bin/keyboard-LED-status.sh' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill

sleep 3
echo "--------------------"
ps auxwww | egrep -i "zikir|xmobar|solat|trayer|LED"
