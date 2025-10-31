#!/usr/bin/env bash

killall -9 xmobar
pgrep -a xmobar | grep 'xmobar /home' | awk '{print $1}' | tr '\n' ' ' | sed 's/$/\n/' | xargs kill
sleep 2
