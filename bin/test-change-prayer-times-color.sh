#!/usr/bin/env bash

# Current time (for example purposes, set to 13:30)
#current_time="13:30"
current_time=$1

# Input line
line="On <fc=#ffffff>2024-12-01</fc> <fc=#ffffff>T13:30:30</fc>; <fc=#ffffff,#ff4d4d>OLD</fc> (<fc=#ff66ff>SGR01</fc> (<fc=#ffff00>Dec</fc> <fc=#00ffff>2024-12-01</fc> <fc=#ffff00>Sun</fc> (<fc=#ffff00>Jmawl</fc> <fc=#00ffff>1446-05-29</fc> <fc=#ffff00>Aha</fc> <fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00>05:42</fc> <fc=#000000,#ffffff>Sub</fc><fc=#000000,#00ff00>05:52</fc> <fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00>07:02</fc> <fc=#000000,#ffffff>Zoh</fc><fc=#000000,#00ff00>13:05</fc> <fc=#000000,#ffffff>Asa</fc><fc=#000000,#00ff00>16:28</fc>) (<fc=#ffff00>Isn</fc> <fc=#000000,#ffffff>Mag</fc><fc=#000000,#00ff00>19:02</fc> <fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00>20:17</fc>)))"

test_time=$(date -d "$current_time + 20 minutes" +"%H:%M")

# Function to convert time to minutes
time_to_minutes() {
    IFS=: read -r h m <<< "$1"
    echo $((10#$h * 60 + 10#$m))
}

# Convert current time to minutes
current_minutes=$(time_to_minutes "$current_time")

# Define background colors based on proximity
bg_color_close="#ffcc00"  # Close (0-30 minutes)
bg_color_medium="#ffff00"  # Medium (31-60 minutes)
bg_color_far="#cccccc"     # Far (more than 60 minutes)

# Process prayer times and names
updated_line="$line"

echo "whiling..."

# Use regex to find all prayer times and their corresponding names
#while [[ $updated_line =~ \<fc=([^\>]*)\>([0-9]{2}:[0-9]{2})\<\/fc\>\s*\<fc=([^\>]*)\>([A-Za-z]+)\<\/fc\ ]]; do
#while [[ $updated_line =~ '\<fc=([^\>]*)\>([0-9]{2}:[0-9]{2})\<\/fc\>\s*\<fc=([^\>]*)\>([A-Za-z]+)\<\/fc\' ]]; do
#while [[ $updated_line =~ "\<fc=[^>]+'([^<]+)'\<\/fc\>\s*\<fc=[^>]+'([A-Za-z]+)'\<\/fc" ]]; do
#while [[ $updated_line =~ "<fc=([^>]*)>([0-9]{2}:[0-9]{2})<\/fc>\s*<fc=([^>]*)>([A-Za-z]+)<\/fc" ]]; do
while [[ $updated_line =~ '<fc=([^>]*)>([0-9]{2}:[0-9]{2})<\/fc>\s*<fc=([^>]*)>([A-Za-z]+)<\/fc' ]]; do
    prayer_time="${BASH_REMATCH[2]}"
    prayer_name="${BASH_REMATCH[4]}"

    echo "$prayer_name: $prayer_time"

    # Convert prayer time to minutes
    prayer_minutes=$(time_to_minutes "$prayer_time")

    # Determine background color based on proximity
    if (( (prayer_minutes - current_minutes) >= 0 && (prayer_minutes - current_minutes) <= 30 )); then
        new_bg_color="$bg_color_close"
    elif (( (prayer_minutes - current_minutes) > 30 && (prayer_minutes - current_minutes) <= 60 )); then
        new_bg_color="$bg_color_medium"
    else
        new_bg_color="$bg_color_far"
    fi

    # Replace the background color for the prayer name in updated_line
    updated_line=$(echo "$updated_line" | sed -E "s|(<fc=[^,]+),([^<]*>$prayer_name<\/fc>)|<fc=\1,$new_bg_color>\2|")
done

echo "survived whiling"

echo "$updated_line"
