#!/usr/bin/env bash

source "$(dirname ${0})/../lib/logger.sh"
LOG_FILE="/tmp/prayer_reminder_log"
set_log_file "$LOG_FILE"

#set_log_level "debug" # "silent", "error", "warn", "info", or "debug". "info" is the default
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

#process_prayer_entry_impure() {
pure_process_prayer_entry() {
    local line="$1"
    local updated_line="$line"
    local result_line="$line"

    local current_time="$2"

    # Toggle state
    #
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

    # Iterate over each match and process the time
    while [[ $updated_line =~ $pattern ]]; do
      foreground="${BASH_REMATCH[2]}"
      background="${BASH_REMATCH[3]}"
      prayer_name="${BASH_REMATCH[1]}"
      prayer_time="${BASH_REMATCH[4]}"

      # Remove the matched part from updated_line to continue searching
      pattern2="${prayer_name}</fc><fc=#${foreground},#${background}> ${prayer_time}"
      updated_line="${updated_line/${pattern2}//}"

      foreground="000000"
      background="7fffd4"

      # Calculate proximity and determine new background color
      if pure_is_near "$prayer_time" "$current_time" 15 && pure_is_started "$current_time" "$prayer_time"; then
        new_colors="ffffff,ff3333"
      elif pure_is_near "$prayer_time" "$current_time" 15; then
        new_colors=$(pure_toggle_colors "$toggle" "ffffff" "ff3333" "000000" "7fffd4") # fg1, bg1, fg2, bg2
      elif pure_is_near "$prayer_time" "$current_time" 30 && pure_is_started "$current_time" "$prayer_time"; then
        new_colors="000000,ffbf00"
      elif pure_is_near "$prayer_time" "$current_time" 30; then
        new_colors=$(pure_toggle_colors "$toggle" "000000" "ffbf00" "000000" "7fffd4") # fg1, bg1, fg2, bg2
      else
        new_colors="${foreground},${background}"
      fi

      # Extract the foreground and background colors
      new_foreground="${new_colors%,*}"
      new_background="${new_colors#*,}"

      # Replace the old match with updated background color
      pattern3="${prayer_name}</fc><fc=#${new_foreground},#${new_background}> ${prayer_time}"
      result_line="${result_line/${pattern2}/${pattern3}}"
    done

    #log_debug "$result_line"
    #echo "$result_line"
    #
    # result_line='<fc=#888888>Data 2024-12-09 21:04:40;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-09</fc> <fc=#00ffff>Mon</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-07</fc> <fc=#ffff00>Isn</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#7fffd4> 05:45 </fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#7fffd4> 05:55 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#7fffd4> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#7fffd4> 13:08 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#7fffd4> 16:31 </fc><fc=#ffff00>)</fc><fc=#ffff00>(Sel</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#7fffd4> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#7fffd4> 20:20 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>'
    # Remove $pattern4 from $result_line
    local pattern4="<fc=#[afA-F0-9]{6},#[afA-F0-9]{6}>Ims</fc><fc=#[afA-F0-9]{6},#[a-fA-F0-9]{6}> [0-9]{2}:[0-9]{2} </fc> "
    local final_result_line=$(echo "$result_line" | sed 's/<fc=#[a-fA-F0-9]\{6\},#[a-fA-F0-9]\{6\}>Ims<\/fc><fc=#[a-fA-F0-9]\{6\},#[a-fA-F0-9]\{6\}> [0-9]\{2\}:[0-9]\{2\} <\/fc>//')
    echo "$final_result_line"
    #log_debug "\$final_result_line=$final_result_line"
}

# - input file
# - output file
# - log file
#main_loop_impure() {
impure_main_loop() {
    local line="$1"
    local fifo="$2"
    local debug_log="$3"
    local toggle=0  # Initial toggle state
    local current_time
    local processed_line

    while true; do
      current_time=$(date +"%H:%M")

      # Process the prayer times using the current toggle state
      #processed_line=$(pure_process_prayer_entry "$line" "$current_time" "$toggle")
      #
      # Write the processed line to FIFO and log
      #echo "$processed_line" | tee -a "$debug_log" > "$fifo"
      #
      pure_process_prayer_entry "$line" "$current_time" "$toggle" > "$fifo"

      # Alternate the toggle state (alternate between 0 and 1)
      toggle=$((1 - $toggle))

      # Wait for 1 second before next loop iteration
      sleep 1
    done
}

impure_main_loop "$(impure_string_from_file "${PRAYER_TIMES_FILE}")" "$PRAYER_REMINDER_FIFO" "$LOG_FILE"
