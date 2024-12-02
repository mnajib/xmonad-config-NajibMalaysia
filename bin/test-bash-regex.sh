#!/usr/bin/env bash

#url="https://example.com"
#if [[ "$url" =~ ^(https?)://([^/]+) ]]; then
#    protocol="${BASH_REMATCH[1]}"
#    domain="${BASH_REMATCH[2]}"
#    echo "Protocol: $protocol"
#    echo "Domain: $domain"
#else
#    echo "Invalid URL"
#fi

# Your original input line
line="On <fc=#ffffff>2024-12-01</fc> <fc=#ffffff>T13:30:30</fc>; <fc=#ffffff,#ff4d4d>OLD</fc> (<fc=#ff66ff>SGR01</fc> (<fc=#ffff00>Dec</fc> <fc=#00ffff>2024-12-01</fc> <fc=#ffff00>Sun</fc> (<fc=#ffff00>Jmawl</fc> <fc=#00ffff>1446-05-29</fc> <fc=#ffff00>Aha</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00>05:42</fc> <fc=#000000,#ffffff>Sub</fc><fc=#000000,#00ff00>05:52</fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00>07:02</fc> <fc=#000000,#ffffff>Zoh</fc><fc=#000000,#00ff00>13:05</fc> <fc=#000000,#ffffff>Asa</fc><fc=#000000,#00ff00>16:28</fc>) (<fc=#ffff00>Isn</fc> <fc=#000000,#ffffff>Mag</fc><fc=#000000,#00ff00>19:02</fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00>20:17</fc>)))"
echo "${line}"

#updated_line="On <fc=#ffffff>2024-12-01</fc> <fc=#ffffff>T13:30:30</fc>; <fc=#ffffff,#ff4d4d>OLD</fc> (<fc=#ff66ff>SGR01</fc> (<fc=#ffff00>Dec</fc> <fc=#00ffff>2024-12-01</fc> <fc=#ffff00>Sun</fc> (<fc=#ffff00>Jmawl</fc> <fc=#00ffff>1446-05-29</fc> <fc=#ffff00>Aha</fc>
# <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00>05:42</fc>
# <fc=#000000,#ffffff>Sub</fc><fc=#000000,#00ff00>05:52</fc>
# <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00>07:02</fc>
# <fc=#000000,#ffffff>Zoh</fc><fc=#000000,#00ff00>13:05</fc>
# <fc=#000000,#ffffff>Asa</fc><fc=#000000,#00ff00>16:28</fc>
#) (<fc=#ffff00>Isn</fc>
# <fc=#000000,#ffffff>Mag</fc><fc=#000000,#00ff00>19:02</fc>
# <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00>20:17</fc>
#)))"

# Test regex
#if [[ $updated_line =~ "\<fc=[^>]+'([0-9]{2}:[0-9]{2})'\<\/fc\>\s*\<fc=[^>]+'([A-Za-z]+)'\<\/fc" ]]; then
#if [[ $updated_line =~ <fc=([^\>]*)>([0-9]{2}:[0-9]{2})<\/fc>\s*<fc=([^\>]*)>([A-Za-z]+)<\/fc ]]; then
#if [[ $updated_line =~ '\<fc=([^\>]*)\>([0-9]{2}:[0-9]{2})<\/fc>\s*\<fc=([^\>]*)\>([A-Za-z]+)<\/fc' ]]; then
#if [[ $updated_line =~ (Zoh).*([0-9]{2}:[0-9]{2}) ]]; then
#if [[ $updated_line =~ (Zoh)\</fc\>\<fc=#000000,#([a-fA-F0-9]{6}|[a-fA-F0-9]{3}).*([0-9]{2}:[0-9]{2}) ]]; then

# Working
#if [[ $updated_line =~ (Zoh)\</fc\>\<fc=#000000,#([a-fA-F0-9]{6}).*([0-9]{2}:[0-9]{2}) ]]; then

# Working
#pattern='(Zoh)</fc><fc=#000000,#([a-fA-F0-9]{6}).*([0-9]{2}:[0-9]{2})'
#if [[ $updated_line =~ $pattern ]]; then

result_line=$line
updated_line="On <fc=#ffffff>2024-12-01</fc> <fc=#ffffff>T13:30:30</fc>; <fc=#ffffff,#ff4d4d>OLD</fc> (<fc=#ff66ff>SGR01</fc> (<fc=#ffff00>Dec</fc> <fc=#00ffff>2024-12-01</fc> <fc=#ffff00>Sun</fc> (<fc=#ffff00>Jmawl</fc> <fc=#00ffff>1446-05-29</fc> <fc=#ffff00>Aha</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00>05:42</fc> <fc=#000000,#ffffff>Sub</fc><fc=#000000,#00ff00>05:52</fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00>07:02</fc> <fc=#000000,#ffffff>Zoh</fc><fc=#000000,#00ff00>13:05</fc> <fc=#000000,#ffffff>Asa</fc><fc=#000000,#00ff00>16:28</fc>) (<fc=#ffff00>Isn</fc> <fc=#000000,#ffffff>Mag</fc><fc=#000000,#00ff00>19:02</fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00>20:17</fc>)))"
#pattern='(Zoh)</fc><fc=#000000,#([a-fA-F0-9]{6}).*([0-9]{2}:[0-9]{2})'
pattern='([A-Za-z]{3})</fc><fc=#000000,#([a-fA-F0-9]{6})>([0-9]{2}:[0-9]{2})'
while [[ $updated_line =~ $pattern ]]; do
    #echo "Prayer Name: ${BASH_REMATCH[1]}"
    #echo "Prayer Time Background Color: ${BASH_REMATCH[2]}"
    #echo "Prayer Time: ${BASH_REMATCH[3]}"

    # Remove the matched part from updated_line to continue searching
    #pattern2="${BASH_REMATCH[1]}\</fc\>\<fc=#000000,#${BASH_REMATCH[2]}\>${BASH_REMATCH[3]}"
    pattern2="${BASH_REMATCH[1]}</fc><fc=#000000,#${BASH_REMATCH[2]}>${BASH_REMATCH[3]}"
    updated_line="${updated_line/${pattern2}//}"

    newColor="ff0000"
    pattern3="${BASH_REMATCH[1]}</fc><fc=#000000,#${newColor}>${BASH_REMATCH[3]}"
    result_line="${result_line/${pattern2}/${pattern3}}"
done
echo "${result_line}"
