#!/usr/bin/env bash

echo "solat:"
ps auxwww | grep -v nvim | grep -v grep | grep -v "ps auxwww" | grep -v monitor-solat-process | grep -i "solat"
echo ""
echo "xmobar:"
ps auxwww | grep -v nvim | grep -v grep | grep -v "ps auxwww" | grep -v monitor-solat-process | grep -i "xmobar"
