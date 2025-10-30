#!/usr/bin/env bash

FILE="/tmp/${USER}-movie-mode-status"

while true; do
  cat "${FILE}"  # Simply outputs the file's content
  sleep 3
done
