#!/usr/bin/env bash

PRAYER_TIMES_FILE="/tmp/${USER}-prayer_times_file"
PRAYER_REMINDER_FILE="/tmp/${USER}-prayer_reminder_file"
PRAYER_TIMES_FIFO="/tmp/prayer_times_fifo"
PRAYER_REMINDER_FIFO="/tmp/prayer_reminder_fifo"
FIFO_INPUT="$PRAYER_TIMES_FIFO"
FIFO_OUTPUT="$PRAYER_REMINDER_FIFO"
SOCKET="/tmp/prayer_times_socket"
LOG_FILE="/tmp/prayer_reminder_log"

# Ensure the reminder FIFO exists
[ ! -p "$PRAYER_TIMES_FILE" ] && touch "$PRAYER_TIMES_FILE"
[ ! -p "$PRAYER_REMINDER_FILE" ] && touch "$PRAYER_REMINDER_FILE"
[ ! -p "$PRAYER_TIMES_FIFO" ] && mkfifo "$PRAYER_TIMES_FIFO"
[ ! -p "$PRAYER_REMINDER_FIFO" ] && mkfifo "$PRAYER_REMINDER_FIFO"

# ANSI color codes
RESET="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"

# Pure function to toggle colors
toggle_color() {
    local current_toggle="$1"
    local color1="$2"
    local color2="$3"
    [[ "$current_toggle" -eq 0 ]] && echo "$color1" || echo "$color2"
}

# Function to colorize the prayer time based on proximity to current time
function colorize_time {
  local prayer_time="$1"
  local current_time
  local prayer_seconds
  local current_seconds

  current_time=$(date "+%H:%M")
  prayer_seconds=$(date -d "$prayer_time" +%s)
  current_seconds=$(date +%s)

  local diff=$(( prayer_seconds - current_seconds ))

  if (( diff < 0 )); then
    echo "$RESET$prayer_time"
  elif (( diff < 600 )); then # < 10 minutes
    echo "$RED$prayer_time$RESET"
  elif (( diff < 3600 )); then # < 1 hour
    echo "$YELLOW$prayer_time$RESET"
  else
    echo "$GREEN$prayer_time$RESET"
  fi
}

# Function to highlight the nearest prayer time
function highlight_prayer_time {
  local line="$1"
  local prayer_name="$2"
  local prayer_time="$3"

  echo "${line//$prayer_name<fc=[^>]*>$prayer_time<\/fc>/$prayer_name<fc=#ffffff,#ff0000>$prayer_time<\/fc>}"
}

testdata() {
  echo "On <fc=#ffffff>2024-12-01</fc> <fc=#ffffff>T13:30:30</fc>; <fc=#ffffff,#ff4d4d>OLD</fc> (<fc=#ff66ff>SGR01</fc> (<fc=#ffff00>Dec</fc> <fc=#00ffff>2024-12-01</fc> <fc=#ffff00>Sun</fc> (<fc=#ffff00>Jmawl</fc> <fc=#00ffff>1446-05-29</fc> <fc=#ffff00>Aha</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00>05:42</fc> <fc=#000000,#ffffff>Sub</fc><fc=#000000,#00ff00>05:52</fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00>07:02</fc> <fc=#000000,#ffffff>Zoh</fc><fc=#000000,#00ff00>13:05</fc> <fc=#000000,#ffffff>Asa</fc><fc=#000000,#00ff00>16:28</fc>) (<fc=#ffff00>Isn</fc> <fc=#000000,#ffffff>Mag</fc><fc=#000000,#00ff00>19:02</fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00>20:17</fc>)))"
}

process_prayer_times() {
    local line="$1"
    local current_time=$(date +"%H:%M")
    local updated_line="$line"
    local result_line="$line"
    local background
    local new_background
    local new_foreground
    local prayer_time

    # Regex
    #local pattern='([A-Za-z]{3})</fc><fc=#000000,#([a-fA-F0-9]{6})>([0-9]{2}:[0-9]{2})'
    #local pattern='([A-Za-z]{3})</fc><fc=#([afA-F0-9]{6}),#([a-fA-F0-9]{6})>([0-9]{2}:[0-9]{2})'
    local pattern='([A-Za-z]{3})</fc><fc=#([afA-F0-9]{6}),#([a-fA-F0-9]{6})> ([0-9]{2}:[0-9]{2})'
    local pattern2
    local pattern3

    # Iterate over each match and process the time
    while [[ $updated_line =~ $pattern ]]; do
      background="${BASH_REMATCH[3]}"
      foreground="${BASH_REMATCH[2]}"
      prayer_name="${BASH_REMATCH[1]}"
      prayer_time="${BASH_REMATCH[4]}"

      # Remove the matched part from updated_line to continue searching
      #pattern2="${prayer_name}</fc><fc=#${foreground},#${background}>${prayer_time}"
      pattern2="${prayer_name}</fc><fc=#${foreground},#${background}> ${prayer_time}"
      updated_line="${updated_line/${pattern2}//}"

      # Calculate proximity and determine new background color
      new_background="$background"
      new_foreground="$foreground"
      #local current_time=$(date +"%H:%M")
      if is_near_time "$prayer_time" "$current_time" 15; then
          # Example: red for very near
          #new_background="ff4d4d"
          #new_background="fc6c85"
          #new_background="ff0000"
          new_background="ff3333"
          new_foreground="ffffff"
      #elif is_near_time "$prayer_time" "$current_time" 15; then
      elif is_near_time "$prayer_time" "$current_time" 30; then
          # Example: yellow for near
          new_background="ffbf00"
          #new_background="f9ccac"
      else
          # Keep the original background
          #new_background="$background"
          # Example: lightgreen for far
          #new_background="00ff77"
          new_background="7fffd4"  # Example: lightgreen for far
      fi
      #
      # Replace the old match with updated background color
      #pattern3="${prayer_name}</fc><fc=#${new_foreground},#${new_background}>${prayer_time}"
      pattern3="${prayer_name}</fc><fc=#${new_foreground},#${new_background}> ${prayer_time}"
      result_line="${result_line/${pattern2}/${pattern3}}"
    done

    echo "$result_line"
}

process_prayer_entry_impure() {
    local line="$1"
    #local current_time=$(date +"%H:%M")
    local current_time="$2"
    local updated_line="$line"
    local result_line="$line"
    local background
    local new_background
    local new_foreground
    local prayer_time
    local toggle="$3"

    # Regex
    #local pattern='([A-Za-z]{3})</fc><fc=#000000,#([a-fA-F0-9]{6})>([0-9]{2}:[0-9]{2})'
    #local pattern='([A-Za-z]{3})</fc><fc=#([afA-F0-9]{6}),#([a-fA-F0-9]{6})>([0-9]{2}:[0-9]{2})'
    local pattern='([A-Za-z]{3})</fc><fc=#([afA-F0-9]{6}),#([a-fA-F0-9]{6})> ([0-9]{2}:[0-9]{2})'
    local pattern2
    local pattern3

    # Iterate over each match and process the time
    while [[ $updated_line =~ $pattern ]]; do
      background="${BASH_REMATCH[3]}"
      foreground="${BASH_REMATCH[2]}"
      prayer_name="${BASH_REMATCH[1]}"
      prayer_time="${BASH_REMATCH[4]}"

      # Remove the matched part from updated_line to continue searching
      #pattern2="${prayer_name}</fc><fc=#${foreground},#${background}>${prayer_time}"
      pattern2="${prayer_name}</fc><fc=#${foreground},#${background}> ${prayer_time}"
      updated_line="${updated_line/${pattern2}//}"

      # Calculate proximity and determine new background color
      #new_background="$background"
      #new_foreground="$foreground"
      local new_background
      local new_foreground
      #local current_time=$(date +"%H:%M")
      if is_near_time "$prayer_time" "$current_time" 15; then
          # Example: red for very near
          #new_background="ff4d4d"
          #new_background="fc6c85"
          #new_background="ff0000"
          #new_background="ff3333"
          new_background=$(toggle_color "$toggle" "ff3333" "$background")
          new_foreground="ffffff"
      #elif is_near_time "$prayer_time" "$current_time" 15; then
      elif is_near_time "$prayer_time" "$current_time" 30; then
          # Example: yellow for near
          #new_background="ffbf00"
          #new_background="f9ccac"
          new_background=$(toggle_color "$toggle" "ffbf00" "$background")
          new_foreground="$foreground"
      else
          # Example: lightgreen for far
          #new_background="00ff77"
          #new_background=$(toggle_color "$toggle" "7fffd4" "ffffff")  # Test
          new_background="7fffd4"  # Example: lightgreen for far
          new_foreground="$foreground"
      fi
      #
      # Replace the old match with updated background color
      #pattern3="${prayer_name}</fc><fc=#${new_foreground},#${new_background}>${prayer_time}"
      pattern3="${prayer_name}</fc><fc=#${new_foreground},#${new_background}> ${prayer_time}"
      result_line="${result_line/${pattern2}/${pattern3}}"
    done

    echo "$result_line"
}

main_loop_impure() {
    local line="$1"
    local fifo="$2"
    local debug_log="$3"
    local toggle="$4"  # Current toggle state

    local current_time
    current_time=$(date +"%H:%M")

    # Process the prayer times using the current toggle state
    local processed_line
    processed_line=$(process_prayer_entry_impure "$line" "$current_time" "$toggle")

    # Write the processed line to FIFO and log
    echo "$processed_line" | tee -a "$debug_log" > "$fifo"

    # Calculate the next toggle state (alternate between 0 and 1)
    local next_toggle=$((1 - toggle))

    # Recursive call with updated toggle state
    sleep 1
    main_loop_impure "$line" "$fifo" "$debug_log" "$next_toggle"
}

# Helper function to determine if a time is within proximity
# Pure function to determine if a prayer time is near
is_near_time() {
    local target_time="$1"
    local current_time="$2"
    #local threshold_minutes="$3"
    local proximity="$3"

    # Convert HH:MM to minutes since midnight
    local target_minutes=$((10#${target_time%%:*} * 60 + 10#${target_time##*:}))
    local current_minutes=$((10#${current_time%%:*} * 60 + 10#${current_time##*:}))

    local diff=$((target_minutes - current_minutes))
    #
    # Calculate absolute difference
    #if (( diff < 0 )); then
    #    diff=$(( -diff ))
    #fi
    # Return true if within threshold
    #(( diff <= threshold_minutes ))
    #
    # Absolute difference, within proximity
    [[ ${diff#-} -le "$proximity" ]]
}

# Monitor prayer times from the FIFO and write the colored output to the reminder FIFO
#while true; do
#  # Read from the prayer times FIFO and process the prayer times
#  cat "$PRAYER_TIMES_FIFO" | process_prayer_times_1 > "$PRAYER_REMINDER_FIFO"
#  sleep 1  # Adjust sleep to prevent busy-waiting
#done

#while true; do
#    # Use read with timeout (e.g., 5 seconds)
#    if timeout 5 read -r line < "$FIFO_INPUT"; then
#        #echo "$line" | process_prayer_times_1 > "$PRAYER_REMINDER_FIFO"
#        echo "$line" | process_prayer_times_1 | tee "$PRAYER_REMINDER_FIFO"
#    #else
#    #    echo "Timeout: No data in FIFO after 5 seconds."
#    fi
#    sleep 5
#done

#--------------------------------------------
#while true; do
#  input_string="$( cat ${PRAYER_TIMES_FILE} )"
#
#  #...
#  output_string="$input_string"
#
#  #echo "$output_string" > "$PRAYER_REMINDER_FILE"
#  #echo "$output_string" > "$PRAYER_REMINDER_FIFO"
#  process_prayer_times "$input_string" > "$PRAYER_REMINDER_FIFO"
#  #
#  sleep 1
#done
#--------------------------------------------
#line="Your formatted prayer times line here"
input_string="$( cat ${PRAYER_TIMES_FILE} )"
#main_loop "$line" "$PRAYER_REMINDER_FIFO" "$DEBUG_LOG" 0
main_loop_impure "$input_string" "$PRAYER_REMINDER_FIFO" "$LOG_FILE" 0
#--------------------------------------------

# Monitor prayer times from the FIFO and write the colored output to the reminder FIFO
#while true; do
  #if read -r line < "$PRAYER_TIMES_FIFO"; then
  #  process_prayer_times "$line" > "$PRAYER_REMINDER_FIFO"
  #  #process_prayer_times "$line" | tee -a "$LOG_FILE" > "$PRAYER_REMINDER_FIFO"
  #fi

  # Try to keep $PRAYER_REMINDER_FIFO alive
  #if read -r line < "$PRAYER_REMINDER_FIFO"; then
  #  echo "$line" &> /dev/null
  #fi
  #cat "$PRAYER_REMINDER_FIFO" &> /dev/null

#  sleep 1  # Adjust sleep to prevent busy-waiting
#done

# Main monitoring loop
#tail -f "$FIFO_INPUT" | while read -r line; do
#  processed_line=$(process_prayer_times_2 "$line")
#  echo "$processed_line" > "$FIFO_OUTPUT"
#done

# Read prayer times from the socket
#socat -u UNIX-CONNECT:"$SOCKET" - | while read -r line; do
#    #echo "$line"
#    #echo "$line" | tee "$PRAYER_REMINDER_FIFO"
#    echo "$line" > "$PRAYER_REMINDER_FIFO"
#    #echo "$line" | process_prayer_times_1 | tee "$PRAYER_REMINDER_FIFO"
#done
