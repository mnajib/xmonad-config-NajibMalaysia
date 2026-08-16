#!/usr/bin/env bash
# bin/waktusolat-dasplay-raw.sh
# Reader & Output Stream for Xmobar using pre-rendered Pango XML

PANGO_XML="/run/waktusolat/reminder-xmobar.pango.xml"

# Force line-buffered stdout so xmobar gets updates instantly every second
method1 () {
  exec stdbuf -oL bash -c '
    PANGO_XML="'"$PANGO_XML"'"
    while true; do
        if [[ -f "$PANGO_XML" && -s "$PANGO_XML" ]]; then
            cat "$PANGO_XML"
            echo
        else
            echo "Waiting for reminder-xmobar.pango.xml..."
        fi
        sleep 1
    done
  '
}

method2 () {
  while true; do
    if [[ -f "$PANGO_XML" && -s "$PANGO_XML" ]]; then
        stdbuf -oL cat "$PANGO_XML"
    else
        echo "Waiting for reminder-xmobar.pango.xml..."
    fi
    sleep 1
  done
}

# Force line-buffered output for the entire loop block
method3 () {
  while true; do
      if [[ -f "$PANGO_XML" && -s "$PANGO_XML" ]]; then
          cat "$PANGO_XML"
          echo
      else
          echo "Waiting for reminder-xmobar.pango.xml..."
      fi
      sleep 1
  done | stdbuf -oL
}

# Clean In-Process Line Buffering (Recommended)
# Use standard Bash + Coreutils, so it build-in everywhere.
method4 () {
  # Direct stdout through stdbuf once for the entire function context
  exec > >(stdbuf -oL cat)

  while true; do
    if [[ -f "$PANGO_XML" && -s "$PANGO_XML" ]]; then
      cat "$PANGO_XML"
      echo
    else
      echo "Waiting for reminder-xmobar.pango.xml..."
    fi
    sleep 1
  done
}

# Native inotifywait Event-Driven Loop (Most Efficient)
# Requires 'inotify-tools' package to be installed
method5 () {
  exec > >(stdbuf -oL cat)

  while true; do
    if [[ -f "$PANGO_XML" && -s "$PANGO_XML" ]]; then
      cat "$PANGO_XML"
      echo
      # Block until the file is written to or replaced atomically
      inotifywait -q -e close_write,move,attrib "$(dirname "$PANGO_XML")" >/dev/null 2>&1 || sleep 1
    else
      echo "Waiting for reminder-xmobar.pango.xml..."
      sleep 1
    fi
  done
}

method6 () {
  while true; do
    if [[ -f "$PANGO_XML" && -s "$PANGO_XML" ]]; then
      cat "$PANGO_XML"
      echo
    else
      echo "Waiting for reminder-xmobar.pango.xml..."
    fi
    sleep 1
  done
}

#method1
method4
#method5
#method6
