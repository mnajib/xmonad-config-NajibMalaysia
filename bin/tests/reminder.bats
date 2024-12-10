#!/usr/bin/env bats

load ../lib/logger.sh
load ../lib/maybe.sh
load ../lib/helpers.sh  # Include helper functions for testing

# Test the `toggle_colors` function
@test "toggle_colors toggles between colors correctly" {
  result=$(pure_toggle_colors 0 "ffffff" "000000" "ff3333" "7fffd4")
  [ "$result" = "ffffff,000000" ]

  result=$(pure_toggle_colors 1 "ffffff" "000000" "ff3333" "7fffd4")
  [ "$result" = "ff3333,7fffd4" ]
}

# Test the `extract_prayer_times` function
#@test "extract_prayer_times parses prayer times correctly" {
#  local input="Fajr:05:42-06:00"
#  result=$(extract_prayer_times "$input")
#  [ "$result" = "05:42-06:00" ]
#}

# Test the `is_started` function
#@test "is_started detects if prayer time has started" {
#  local current_time="06:00"
#  local prayer_time="05:42-06:00"
#  result=$(is_started "$current_time" "$prayer_time")
#  [ "$result" = "1" ]
#
#  local current_time="05:30"
#  result=$(is_started "$current_time" "$prayer_time")
#  [ "$result" = "0" ]
#}
