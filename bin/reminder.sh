#!/usr/bin/env bash

source "$(dirname ${0})/../lib/logger.sh"
LOG_FILE="/tmp/prayer_reminder_log"
set_log_file "$LOG_FILE"
#set_log_level "debug" # "silent", "error", "warn", "info", "debug"
log_debug "LOG_FILE: ${LOG_FILE}"
log_debug "LOG_LEVEL: ${LOG_LEVEL}"

# Source the library
source "$(dirname ${0})/../lib/maybe.sh"
source "$(dirname ${0})/../lib/helpers.sh"

PRAYER_TIMES_FILE="/tmp/${USER}-prayer_times_file"
#PRAYER_REMINDER_FILE="/tmp/${USER}-prayer_reminder_file"
PRAYER_TIMES_FIFO="/tmp/prayer_times_fifo"
PRAYER_REMINDER_FIFO="/tmp/prayer_reminder_fifo"
FIFO_INPUT="$PRAYER_TIMES_FIFO"
FIFO_OUTPUT="$PRAYER_REMINDER_FIFO"
#SOCKET="/tmp/prayer_times_socket"

# Ensure the reminder FIFO exists
[ ! -p "$PRAYER_TIMES_FILE" ] && touch "$PRAYER_TIMES_FILE"
# [ ! -p "$PRAYER_REMINDER_FILE" ] && touch "$PRAYER_REMINDER_FILE"
[ ! -p "$PRAYER_TIMES_FIFO" ] && mkfifo "$PRAYER_TIMES_FIFO"
[ ! -p "$PRAYER_REMINDER_FIFO" ] && mkfifo "$PRAYER_REMINDER_FIFO"

# ANSI color codes
RESET="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"

process_prayer_entry_impure() {
    local line="$1"
    local updated_line="$line"
    local result_line="$line"

    local current_time="$2"

    #local toggle="$3"
    #
    #local toggle
    #case "$3" in
    #  '')
    #   toggle="0"
    #   ;;
    #  *)
    #   toggle="$3"
    #   ;;
    #esac
    #
    # NOTE: To ensure $3 has a default value:
    # default="0"
    # ${parameter:-${default}}
    # ${parameter-${default}}
    # ${parameter:=${default}}
    local toggle="${3:-0}"

    local foreground
    local background
    local new_foreground
    local new_background
    local new_colors

    local prayer_name
    local prayer_time

    # Regex
    local pattern='([A-Za-z]{3})</fc><fc=#([afA-F0-9]{6}),#([a-fA-F0-9]{6})> ([0-9]{2}:[0-9]{2})'
    local pattern2
    local pattern3

    # Iterate over each match and process the time
    while [[ $updated_line =~ $pattern ]]; do
      foreground="${BASH_REMATCH[2]}"
      background="${BASH_REMATCH[3]}"
      prayer_name="${BASH_REMATCH[1]}"
      prayer_time="${BASH_REMATCH[4]}"

      foreground="000000"
      background="7fffd4"

      # Remove the matched part from updated_line to continue searching
      pattern2="${prayer_name}</fc><fc=#${foreground},#${background}> ${prayer_time}"
      updated_line="${updated_line/${pattern2}//}"

      # Calculate proximity and determine new background color
      if is_near_time "$prayer_time" "$current_time" 15 && is_started "$current_time" "$prayer_time"; then
        new_colors="ffffff,ff3333"
      elif is_near_time "$prayer_time" "$current_time" 15; then
        new_colors=$(toggle_colors "$toggle" "ffffff" "ff3333" "000000" "7fffd4") # fg1, bg1, fg2, bg2
        # ---------------------------------------------------------------
        # NOTE:
        #   value="abc,def,ghi"
        #   result="${value#*,}"
        #   #: The # operator works on the beginning of the string.
        #   *: Matches everything (any sequence of characters).
        #   ,: Ensures the match stops at the first comma it encounters.
        #   "Including the first comma": The pattern *, explicitly includes the comma in the match, so it's removed as well.
        #
        #   #*,: Remove the match regex patern '#*,' meaning remove from start, and then anythings until and including comma.
        #   %,*: Remove the match regex patern '%,*' meaning remove until the end, start with comma, and then anytings.
        # ---------------------------------------------------------------
        #new_foreground="${new_colors%,*}"
        #new_background="${new_colors#*,}"
      elif is_near_time "$prayer_time" "$current_time" 30 && is_started "$current_time" "$prayer_time"; then
        new_colors="000000,ffbf00"
      elif is_near_time "$prayer_time" "$current_time" 30; then
        new_colors=$(toggle_colors "$toggle" "000000" "ffbf00" "000000" "7fffd4") # fg1, bg1, fg2, bg2
        #new_foreground="${new_colors%,*}"
        #new_background="${new_colors#*,}"
      else
        #new_foreground="000000"
        #new_background="7fffd4"  # Example: lightgreen for far
        #new_colors="000000,7fffd4"
        new_colors="${foreground},${background}"
      fi

      # Extract the foreground and background colors
      new_foreground="${new_colors%,*}"
      new_background="${new_colors#*,}"

      #
      # Replace the old match with updated background color
      pattern3="${prayer_name}</fc><fc=#${new_foreground},#${new_background}> ${prayer_time}"
      result_line="${result_line/${pattern2}/${pattern3}}"
    done

    echo "$result_line"
}

main_loop_impure() {
    local line="$1"
    local fifo="$2"
    local debug_log="$3"
    local toggle=0  # Initial toggle state
    local current_time
    local processed_line

    while true; do
      current_time=$(date +"%H:%M")

      # Process the prayer times using the current toggle state
      #processed_line=$(process_prayer_entry_impure "$line" "$current_time" "$toggle")
      #
      # Write the processed line to FIFO and log
      #echo "$processed_line" | tee -a "$debug_log" > "$fifo"
      #
      process_prayer_entry_impure "$line" "$current_time" "$toggle" > "$fifo"

      # Alternate the toggle state (alternate between 0 and 1)
      toggle=$((1 - $toggle))

      # Wait for 1 second before next loop iteration
      sleep 1
    done
}

# #############################################################################

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
#input_string="$( cat ${PRAYER_TIMES_FILE} )"
#main_loop "$line" "$PRAYER_REMINDER_FIFO" "$DEBUG_LOG" 0
#main_loop_impure "$input_string" "$PRAYER_REMINDER_FIFO" "$LOG_FILE" 0
#main_loop_impure "$input_string" "$PRAYER_REMINDER_FIFO" "$LOG_FILE"
#--------------------------------------------
main_loop_impure "$(get_input_string "${PRAYER_TIMES_FILE}")" "$PRAYER_REMINDER_FIFO" "$LOG_FILE"

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
