#!/usr/bin/env bats

load ../bin/lib/logger.sh
load ../bin/lib/maybe.sh
load ../bin/lib/helpers.sh

#-----------------------------------------------------------------------------------
# Test the pure_extract_prayer_times

@test "pure_extract_prayer_times: output singgle line space-separated format" {
  #local input_line="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00> 05:46 </fc> <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#00ff00> 05:56 </fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00> 07:06 </fc> <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#00ff00> 13:09 </fc> <fc=#000000,#ffffff>Asr</fc><fc=#000000,#00ff00> 16:31 </fc><fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#00ff00> 19:06 </fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00> 20:21 </fc><fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
  local input_line="<fc=#888888>Data 2024-12-10 21:37:43;</fc>     <fc=#ff66ff>(SGR01</fc> <fc=#00ffff>(Dec</fc> <fc=#00ffff>2024-12-10</fc> <fc=#00ffff>Tue</fc> <fc=#ffff00>(Jmakh</fc> <fc=#ffff00>1446-06-08</fc> <fc=#ffff00>Sel</fc> \
    <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00> 05:46 </fc> \
    <fc=#000000,#ffffff>Fjr</fc><fc=#000000,#00ff00> 05:56 </fc> \
    <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00> 07:06 </fc> \
    <fc=#000000,#ffffff>Zhr</fc><fc=#000000,#00ff00> 13:09 </fc> \
    <fc=#000000,#ffffff>Asr</fc><fc=#000000,#00ff00> 16:31 </fc>\
    <fc=#ffff00>)</fc> <fc=#ffff00>(Rab</fc> \
    <fc=#000000,#ffffff>Mgh</fc><fc=#000000,#00ff00> 19:06 </fc> \
    <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00> 20:21 </fc>\
    <fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
  #local expected_output_line="Fajr:05:42-06:00 Dhuhr:13:05-13:30 Asr:16:28-17:00 Maghrib:19:02-19:30 Isha:20:17-20:45"
  local expected_output_line="\
    Ims:05:46-05:56 \
    Fjr:05:56-07:06 \
    Zhr:13:09-16:31 \
    Asr:16:31-19:06 \
    Mgh:19:06-20:21 \
    Isy:20:21-05:56"
  result=$(pure_extract_prayer_times "$input_line")
  [ "$result" = "$expected_output_line" ]
}
