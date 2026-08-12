#!/usr/bin/env bash

#PRAYER_REMINDER_FILE="/tmp/${USER}-prayer_reminder_file"
PRAYER_REMINDER_FILE="/run/user/${UID}/waktusolat/prayer_reminder.xmobar"
PRAYER_REMINDER_FILE2="/run/waktusolat/reminder.txt"

while true; do

    #cat ${PRAYER_REMINDER_FILE}

    # TEST:
    #cat /run/user/1001/waktusolat/prayer_reminder.xmobar /run/waktusolat/reminder.txt | tr -d '\n'
    cat ${PRAYER_REMINDER_FILE} ${PRAYER_REMINDER_FILE2} | tr -d '\n'
    echo

    sleep 1
done
