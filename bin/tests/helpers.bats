#!/usr/bin/env bats

load ../lib/logger.sh
load ../lib/maybe.sh
load ../lib/helpers.sh

# Test the `get_input_string` function
#@test "get_input_string reads file content" {
#  local test_file="/tmp/test_prayer_times.txt"
#  echo "Fajr:05:42-06:00" > "$test_file"
#
#  result=$(get_input_string "$test_file")
#  [ "$result" = "Fajr:05:42-06:00" ]
#
#  rm -f "$test_file"
#}

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

# NOTE:
#   0 True
#   1 False

#-----------------------------------------------------------------------------------
# Test the `pure_is_near_time` function
@test "pure_is_near_time return false when time different is more than 15 minutes (before)" {
  local current_time="18:40"
  local prayer_start_time="19:00"
  local proximity=15
  result=$(pure_is_near_time "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "1" ] # False
}

@test "pure_is_near_time return true when time different is 15 minutes (before)" {
  local current_time="18:45"
  local prayer_start_time="19:00"
  local proximity=15
  result=$(pure_is_near_time "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "0" ] # True
}

@test "pure_is_near_time return true when time different is less than 15 minutes (before)" {
  local current_time="18:50"
  local prayer_start_time="19:00"
  local proximity=15
  result=$(pure_is_near_time "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "0" ] # True
}

@test "pure_is_near_time return true when time different is 0" {
  local current_time="19:00"
  local prayer_start_time="19:00"
  local proximity=15
  result=$(pure_is_near_time "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "0" ] # True
}

@test "pure_is_near_time return true when time different is less than 15 minutes (after)" {
  local current_time="19:05"
  local prayer_start_time="19:00"
  local proximity=15
  result=$(pure_is_near_time "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "0" ] # True
}

@test "pure_is_near_time return true when time different is 15 minutes (after)" {
  local current_time="19:15"
  local prayer_start_time="19:00"
  local proximity=15
  result=$(pure_is_near_time "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "0" ] # True
}

@test "pure_is_near_time return false when time different is more than 15 minutes (after)" {
  local current_time="19:20"
  local prayer_start_time="19:00"
  local proximity=15
  result=$(pure_is_near_time "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "1" ] # False
}

@test "pure_is_near_time return false when time recieved is garbage-1" {
  local current_time="19:05"
  local prayer_start_time="05:42-06:00"
  local proximity=15
  result=$(pure_is_near_time "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "1" ] # False
}

@test "pure_is_near_time return false when time recieved is garbage-2" {
  local current_time="05:43"
  local prayer_start_time="05:42-06:00"
  local proximity=15
  result=$(pure_is_near_time "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "1" ] # False
}

@test "pure_is_near_time return false when time recieved is garbage-3" {
  local current_time="05:55"
  local prayer_start_time="05:42-06:00"
  local proximity=15
  result=$(pure_is_near_time "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "1" ] # False
}

#-----------------------------------------------------------------------------------
# Test the `pure_is_near` function
@test "pure_is_near return false when current time is less than prayer start time" {
  local current_time="19:05"
  local prayer_start_time="19:06"
  local proximity=15
  result=$(pure_is_near "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "1" ]
}

@test "pure_is_near return true when current time is equals to prayer start time" {
  local current_time="19:06"
  local prayer_start_time="19:06"
  local proximity=15
  result=$(pure_is_near "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "0" ]
}

@test "pure_is_near return true when current time is greater than prayer start time" {
  local current_time="19:07"
  local prayer_start_time="19:06"
  local proximity=15
  result=$(pure_is_near "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "0" ]
}

@test "pure_is_near return false when current_time or prayer_start_time is not in recognize format" {
  local current_time="19:05"
  local prayer_start_time="05:42-06:00"
  local proximity=15
  result=$(pure_is_near "$prayer_start_time" "$current_time" $proximity)
  [ "$result" = "1" ]
}

#-----------------------------------------------------------------------------------
# Test the `pure_is_started` function
@test "pure_is_started return false when current time is less than prayer start time" {
  local current_time="19:05"
  local prayer_start_time="19:06"
  result=$(pure_is_started "$current_time" "$prayer_start_time")
  [ "$result" = "1" ]
}

@test "pure_is_started return true when current time is equals to prayer start time" {
  local current_time="19:06"
  local prayer_start_time="19:06"
  result=$(pure_is_started "$current_time" "$prayer_start_time")
  [ "$result" = "0" ]
}

@test "pure_is_started return true when current time is greater than prayer start time" {
  local current_time="19:07"
  local prayer_start_time="19:06"
  result=$(pure_is_started "$current_time" "$prayer_start_time")
  [ "$result" = "0" ] # true
}

@test "pure_is_started return false when current_time or prayer_start_time is not in recognize format" {
  local current_time="19:05"
  local prayer_start_time="05:42-06:00"
  result=$(pure_is_started "$current_time" "$prayer_start_time")
  [ "$result" = "1" ] # Nothing. Error. ...
}
