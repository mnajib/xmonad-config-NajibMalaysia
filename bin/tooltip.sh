#!/usr/bin/env bash

#
# To get fonts on system:
#   xlsfonts | grep -i fixed
#

#FONT='monospace'
#FONT='fixed'
FONT='-misc-fixed-*-*-*-*-12-*-*-*-*-*-*-*'
TITLE=$(xdotool getwindowfocus getwindowname)
PADDED_TITLE="  $TITLE  "  # Add two spaces before and after
X=$(xdotool getmouselocation --shell | grep X= | cut -d= -f2)
Y=$(xdotool getmouselocation --shell | grep Y= | cut -d= -f2)
WIDTH=$(textwidth "$FONT" "$PADDED_TITLE")

echo "$PADDED_TITLE" | dzen2 -p 3 \
  -x $((X + 10)) -y $((Y + 10)) -w $WIDTH -h 24 \
  -ta l \
  -bg '#222222' -fg '#ffffff' \
  -fn "$FONT"

