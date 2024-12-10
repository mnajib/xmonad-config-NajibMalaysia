#!/usr/bin/env bats

load ../lib/logger.sh
load ../lib/maybe.sh
load ../lib/helpers.sh

# Test the `pure_process_prayer_entry` function

@test "pure_process_prayer_entry when not in any prayer time, toggle_state=0" {
  #local line="Fajr:05:42-06:00"
  #local line="$(pure_testdata)"
  local current_time="10:00"
  local toggle_state=0
  local            line="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00> 05:46 </fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#00ff00> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#00ff00> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#00ff00> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#00ff00> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
                                                               local intended_result="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#7fffd4> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#7fffd4> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#7fffd4> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#7fffd4> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#7fffd4> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#7fffd4> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
  result=$(pure_process_prayer_entry "$line" "$current_time" "$toggle_state")
  #[ "$result" = "Fajr is near: 05:42-06:00" ]
  [ "$result" = "$intended_result" ]
}

@test "pure_process_prayer_entry when not in any prayer time, toggle_state=1" {
  local current_time="10:00"
  local toggle_state=1
  local            line="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00> 05:46 </fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#00ff00> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#00ff00> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#00ff00> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#00ff00> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
                                                               local intended_result="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#7fffd4> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#7fffd4> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#7fffd4> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#7fffd4> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#7fffd4> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#7fffd4> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
  result=$(pure_process_prayer_entry "$line" "$current_time" "$toggle_state")
  [ "$result" = "$intended_result" ]
}

@test "pure_process_prayer_entry when in 15 minutes before start Zohor, toggle_state=0" {
  local current_time="13:00"
  local toggle_state=0
  local            line="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00> 05:46 </fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#00ff00> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#00ff00> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#00ff00> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#00ff00> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
                                                               local intended_result="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#7fffd4> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#7fffd4> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#ffffff,#ff3333> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#7fffd4> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#7fffd4> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#7fffd4> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
  result=$(pure_process_prayer_entry "$line" "$current_time" "$toggle_state")
  [ "$result" = "$intended_result" ]
}

@test "pure_process_prayer_entry when in 15 minutes before start Zohor, toggle_state=1" {
  local current_time="13:00"
  local toggle_state=1
  local            line="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00> 05:46 </fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#00ff00> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#00ff00> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#00ff00> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#00ff00> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
                                                               local intended_result="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#7fffd4> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#7fffd4> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#7fffd4> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#7fffd4> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#7fffd4> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#7fffd4> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
  result=$(pure_process_prayer_entry "$line" "$current_time" "$toggle_state")
  [ "$result" = "$intended_result" ]
}

@test "pure_process_prayer_entry when in 30 minutes before start Zohor, toggle_state=0" {
  local current_time="12:40"
  local toggle_state=0
  local            line="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00> 05:46 </fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#00ff00> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#00ff00> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#00ff00> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#00ff00> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
                                                               local intended_result="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#7fffd4> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#7fffd4> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#ffbf00> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#7fffd4> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#7fffd4> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#7fffd4> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
  result=$(pure_process_prayer_entry "$line" "$current_time" "$toggle_state")
  [ "$result" = "$intended_result" ]
}

@test "pure_process_prayer_entry when in 30 minutes before start Zohor, toggle_state=1" {
  local current_time="12:40"
  local toggle_state=1
  local            line="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00> 05:46 </fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#00ff00> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#00ff00> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#00ff00> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#00ff00> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
                                                               local intended_result="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#7fffd4> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#7fffd4> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#7fffd4> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#7fffd4> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#7fffd4> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#7fffd4> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
  result=$(pure_process_prayer_entry "$line" "$current_time" "$toggle_state")
  [ "$result" = "$intended_result" ]
}
