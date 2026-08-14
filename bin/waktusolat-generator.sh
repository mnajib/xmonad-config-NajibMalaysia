#!/usr/bin/env bash
# bin/waktusolat-generator.sh
# Sub-Job 1: Parses reminder.json and writes formatted string to reminder.xmobar

BASE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
STATE_DIR="${BASE_DIR}/waktusolat"

REMINDER_JSON="/run/waktusolat/reminder.json"
REMINDER_XMOBAR="${STATE_DIR}/reminder.xmobar"

mkdir -p "$STATE_DIR"

while true; do
    if [[ -f "$REMINDER_JSON" && -s "$REMINDER_JSON" ]]; then
        epoch=$(date +%s)
        toggle=$(( epoch % 2 ))

        rendered=$(jq -r --argjson toggle "$toggle" '
          try (
            . as $root |

            def get_bg(stage; default_bg):
              if stage == "blink_amber" then
                (if $toggle == 1 then "ffbf00" else "7fffd4" end)
              elif stage == "blink_red" then
                (if $toggle == 1 then "ff0000" else "7fffd4" end)
              elif stage == "solid_red" then "ff3333"
              elif stage == "solid_amber" then "ffbf00"
              else default_bg
              end;

            def get_fg(stage; default_fg):
              if stage == "blink_red" and $toggle == 1 then "ffffff"
              elif stage == "solid_red" then "ffffff"
              else default_fg
              end;

            def p(key; lbl):
              (($root.prayers // {})[key] // {}) as $item |
              ($item.time // "-") as $t |
              ($item.stage // "neutral") as $st |
              get_fg($st; ($item.fg // "000000")) as $fg |
              get_bg($st; ($item.bg // "7fffd4")) as $bg |
              "<fc=#000000,#ffffff>" + lbl + "</fc><fc=#" + $fg + ",#" + $bg + "> " + $t + " </fc>";

            "<fc=#888888>Data " + ($root.server_time // "") + ";</fc>" +
            (if $root.is_stale == true then "<fc=#ff0000,#000000> OLD </fc>" else "     " end) +
            "<fc=#ff66ff>(" + ($root.zone // "") + "</fc> " +
            "<fc=#00ffff>(" + ($root.gregorian.month_abb // "") + " " + ($root.gregorian.date // "") + " " + ($root.gregorian.day_abb // "") + "</fc> " +
            "<fc=#ffff00>(" + ($root.hijri.month_name // "") + " " + ($root.hijri.date // "") + " " + ($root.hijri.day_name // "") + "</fc> " +
            p("fajr"; "Fjr") + " " +
            p("syuruk"; "Syu") + " " +
            p("zohor"; "Zhr") + " " +
            p("asr"; "Asr") +
            "<fc=#ffff00>)</fc> " +
            "<fc=#ffff00>(" + ($root.hijri.next_day_name // "") + "</fc> " +
            p("maghrib"; "Mgh") + " " +
            p("isha"; "Isy") +
            "<fc=#ffff00>)</fc><fc=#00ffff>)</fc><fc=#ff66ff>)</fc>"
          ) catch "Parsing error..."
        ' "$REMINDER_JSON" 2>/dev/null)

        if [[ -n "$rendered" ]]; then
            # Direct in-place truncation preserves the inode
            printf "%s\n" "$rendered" > "$REMINDER_XMOBAR"
        fi
    else
        printf "Waiting for reminder.json...\n" > "$REMINDER_XMOBAR"
    fi

    sleep 1
done
