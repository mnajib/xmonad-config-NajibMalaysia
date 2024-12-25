#!/usr/bin/env bash

PRAYER_REMINDER_FILE="/tmp/${USER}-prayer_reminder_file"

while true; do
    cat ${PRAYER_REMINDER_FILE}
    sleep 1
done
