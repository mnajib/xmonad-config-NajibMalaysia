#!/usr/bin/env bash

# Guard clause to prevent multiple inclusions of this file
[[ "${_HELPERS_SH_INCLUDED:-}" == "true" ]] && return
declare -r _HELPERS_SH_INCLUDED="true"
log_debug "Sourcing helpers.sh"

# helpers.sh: Project-Specific Helper Functions
# Purpose: Functions in helpers.sh are specific to your project
# and assist in implementing project-related logic. They typically
# provide higher-level functionality or integrate with other project components.

#source "$(dirname ${0})/lib/logger.sh"
#source "$(dirname ${0})/lib/maybe.sh"

# Pure function to toggle colors
#toggle_color_pure() {
pure_toggle_color() {
    local current_toggle="$1"
    local color1="$2"
    local color2="$3"
    [[ "$current_toggle" -eq 0 ]] && echo "$color1" || echo "$color2"
}

# input:  fg1 bg1 fg2 bg2
# output: fg2 bg2 fg1 bg1
#toggle_colors_pure() {
pure_toggle_colors() {
    local toggle="$1"
    local fg1="$2" bg1="$3"
    local fg2="$4" bg2="$5"

    if [[ "$toggle" -eq 0 ]]; then
        echo "$fg1,$bg1"
    else
        echo "$fg2,$bg2"
    fi
}

# Function to colorize the prayer time based on proximity to current time
#colorize_time() {
impure_colorize_time() {
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

pure_sound_a_beep() {
  echo -e "\a"
  #printf "\a"
}

#
# PRAYER_TIMES=(
#    "Fajr:05:42-06:00"
#    "Dhuhr:13:05-13:30"
#    "Asr:16:28-17:00"
#    "Maghrib:19:02-19:30"
#    "Isha:20:17-20:45"
# )
# input_string=$(cat "$PRAYER_TIMES_FILE")
# process_prayer_times_impure "$input_string" "$PRAYER_REMINDER_FIFO" "$LOG_FILE"
#
#extract_prayer_times_pure() {
pure_extract_prayer_times() {
    local input_line="$1"
    local pattern='your-regex-here'  # TODO: Replace with actual regex
    local prayer_times=()  # Initialize a local array

    while [[ $input_line =~ $pattern ]]; do
        local prayer_name="${BASH_REMATCH[1]}"
        local prayer_time="${BASH_REMATCH[4]}"

        # Append the formatted string to the local array
        prayer_times+=("${prayer_name}:${prayer_time}")

        # Remove the matched portion from the input line to process the next match
        input_line="${input_line#${BASH_REMATCH[0]}}"
    done

    # Output the array as a single line (space-separated)
    echo "${prayer_times[@]}"
}

# Function to highlight the nearest prayer time
#highlight_prayer_time() {
pure_highlight_prayer_time() {
  local line="$1"
  local prayer_name="$2"
  local prayer_time="$3"

  echo "${line//$prayer_name<fc=[^>]*>$prayer_time<\/fc>/$prayer_name<fc=#ffffff,#ff0000>$prayer_time<\/fc>}"
}

#testdata_pure() {
pure_testdata() {
  echo "On <fc=#ffffff>2024-12-01</fc> <fc=#ffffff>T13:30:30</fc>; <fc=#ffffff,#ff4d4d>OLD</fc> (<fc=#ff66ff>SGR01</fc> (<fc=#ffff00>Dec</fc> <fc=#00ffff>2024-12-01</fc> <fc=#ffff00>Sun</fc> (<fc=#ffff00>Jmawl</fc> <fc=#00ffff>1446-05-29</fc> <fc=#ffff00>Aha</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00>05:42</fc> <fc=#000000,#ffffff>Sub</fc><fc=#000000,#00ff00>05:52</fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00>07:02</fc> <fc=#000000,#ffffff>Zoh</fc><fc=#000000,#00ff00>13:05</fc> <fc=#000000,#ffffff>Asa</fc><fc=#000000,#00ff00>16:28</fc>) (<fc=#ffff00>Isn</fc> <fc=#000000,#ffffff>Mag</fc><fc=#000000,#00ff00>19:02</fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00>20:17</fc>)))"
}

# Helper function to determine if a time is within proximity
# Pure function to determine if a prayer time is near
#is_near_time_pure() {
pure_is_near_time() {
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
    #[[ ${diff#-} -le "$proximity" ]]
    #
    if [[ ${diff#-} -le "$proximity" ]]; then
      echo 0
    else
      echo 1
    fi
}

#is_near_pure() {
pure_is_near() {
    local current_time="$1"
    local start_time="$2"
    local range_minutes="$3"

    local current_minutes=$((10#${current_time%%:*} * 60 + 10#${current_time##*:}))
    local start_minutes=$((10#${start_time%%:*} * 60 + 10#${start_time##*:}))

    # Check if the current time is within the range from the start time
    #(( start_minutes - current_minutes <= range_minutes && current_minutes < start_minutes ))
    #if (( start_minutes - current_minutes <= range_minutes && current_minutes < start_minutes )); then
    if (( start_minutes - current_minutes <= range_minutes && current_minutes <= start_minutes )); then
        #return 0  # 0 indicates true, meaning the current time is within the range
        echo 0  # 0 indicates true, meaning the current time is within the range
    else
        #return 1  # 1 indicates false, meaning the current time is not within the range
        echo 1  # 1 indicates false, meaning the current time is not within the range
    fi
}

#is_within_range_pure() {
pure_is_within_range() {
    local current_time="$1"
    local start_time="$2"
    local end_time="$3"

    local current_minutes=$((10#${current_time%%:*} * 60 + 10#${current_time##*:}))
    local start_minutes=$((10#${start_time%%:*} * 60 + 10#${start_time##*:}))
    local end_minutes=$((10#${end_time%%:*} * 60 + 10#${end_time##*:}))

    [[ "$current_minutes" -ge "$start_minutes" && "$current_minutes" -le "$end_minutes" ]]
}

# Returns true (0) if current_time is greater than or equal to start_time
#   is_started "17:06" "19:04"
#
# Here are a few examples to validate the is_started function:
#   is_started "12:00" "11:59" && echo "Started" || echo "Not Started"
#       Output: Started
#   is_started "12:00" "12:00" && echo "Started" || echo "Not Started"
#       Output: Started
#   is_started "11:58" "12:00" && echo "Started" || echo "Not Started"
#       Output: Not Started
#is_started_pure() {
pure_is_started() {
    local current_time="$1"
    local start_time="$2"

    # Convert times to minutes since midnight
    local current_minutes=$((10#${current_time%%:*} * 60 + 10#${current_time##*:}))
    local start_minutes=$((10#${start_time%%:*} * 60 + 10#${start_time##*:}))

    # Check if the current time is greater than or equal to the start time
    #[[ $current_minutes -ge $start_minutes ]]
    #
    if [[ $current_minutes -ge $start_minutes ]]; then
        echo 0
    else
        echo 1
    fi
}

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

    #log_debug "line=\"$line\""

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

      # Calculate proximity and determine new background color
      if [[ $(pure_is_near_time "$prayer_time" "$current_time" 15) = 0 ]]; then
        if [[ $(pure_is_started "$current_time" "$prayer_time") = 0 ]]; then
          new_colors=$(pure_toggle_colors "$toggle" "ffffff" "ff3333" "ffffff" "ff3333") # fg1, bg1, fg2, bg2
        else
          new_colors=$(pure_toggle_colors "$toggle" "ffffff" "ff3333" "000000" "7fffd4") # fg1, bg1, fg2, bg2
        fi
      elif [[ $(pure_is_near_time "$prayer_time" "$current_time" 30) = 0 ]]; then
        if [[ $(pure_is_started "$current_time" "$prayer_time") = 0 ]]; then
          new_colors=$(pure_toggle_colors "$toggle" "000000" "ffbf00" "000000" "ffbf00") # fg1, bg1, fg2, bg2
        else
          new_colors=$(pure_toggle_colors "$toggle" "000000" "ffbf00" "000000" "7fffd4") # fg1, bg1, fg2, bg2
        fi
      else
        new_colors="000000,7fffd4"
      fi

      # Extract the foreground and background colors
      new_foreground="${new_colors%,*}"
      new_background="${new_colors#*,}"
      #log_debug "new_foreground=${new_foreground}, new_background=${new_background}"

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
    local final_result_line=$(echo "$result_line" | sed 's/<fc=#[a-fA-F0-9]\{6\},#[a-fA-F0-9]\{6\}>Ims<\/fc><fc=#[a-fA-F0-9]\{6\},#[a-fA-F0-9]\{6\}> [0-9]\{2\}:[0-9]\{2\} <\/fc> //')
    echo "$final_result_line"
    log_debug "\$final_result_line=$final_result_line"
    log_info "$final_result_line"
}

# Function: Read prayer times from file
#get_input_string() {
#get_input_string_impure() {
#impure_read_file() {
impure_string_from_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Error: File $file not found." >&2
        return 1
    fi
    cat "$file"
}
