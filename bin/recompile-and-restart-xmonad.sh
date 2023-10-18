#!/usr/bin/env bash

#watch '~/.xmonad/bin/list-running-process.sh'

~/.xmonad/bin/kill2restart.sh

sleep 1

xmonad --recompile && xmonad --restart

sleep 1

~/.xmonad/bin/start-sidetool.sh


