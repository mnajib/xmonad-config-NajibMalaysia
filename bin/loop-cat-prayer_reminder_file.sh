#!/usr/bin/env bash

#PRAYER_REMINDER_FILE="/tmp/${USER}-prayer_reminder_file"
PRAYER_REMINDER_FILE="/run/user/${UID}/waktusolat/prayer_reminder.xmobar"
#PRAYER_REMINDER_FILE="/run/waktusolat/reminder.txt"

while true; do
    cat ${PRAYER_REMINDER_FILE}
    sleep 1
done
