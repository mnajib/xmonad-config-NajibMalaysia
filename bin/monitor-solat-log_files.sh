#!/usr/bin/env bash

FILE1="/tmp/${USER}-wsp.log"
#FILE2="/tmp/${USER}-wsp1.bak"
#FILE3="/tmp/${USER}-prayer_reminder_file"

#echo "${FILE1}"
#echo "---------------------------------"
#cat "${FILE1}"

tail -F "${FILE1}"
