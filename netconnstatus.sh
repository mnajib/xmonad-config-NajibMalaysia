#!/usr/bin/env bash

PING=~/.xmonad/bin/NetConnStatus.sh
#LOGFILE=~/.xmonad/var/${USER}-NetConnStatus.log # date_time, LAN_status, WAN_status

# UP
FgColor1="#181715"
BgColor1="#58C5F1"
# DOWN
FgColor2="#646464"
BgColor2="#ff0000"

timeInterval=2 #5 #10 #15 60

function printStatus {
	case $1 in
		1)
		    # LAN UP, WAN UP
			echo "<fc=${FgColor1},${BgColor1}> LAN</fc>,<fc=${FgColor1},${BgColor1}> WAN</fc>"
			;;
		2)
		    # LAN DOWN, WAN UP (WIERD!)
			echo "<fc=${FgColor2},${BgColor2}> LAN</fc>,<fc=${FgColor1},${BgColor1}> WAN</fc>"
			;;
		3)
		    # LAN UP, WAN DOWN
			echo "<fc=${FgColor1},${BgColor1}> LAN</fc>,<fc=${FgColor2},${BgColor2}> WAN</fc>"
			;;
		4)
		    # LAN DOWN, WAN DOWN
		    echo "<fc=${FgColor2},${BgColor2}> LAN</fc>,<fc=${FgColor2},${BgColor2}> WAN</fc>"
			;;
	esac
}

while true; do
	${PING} enp7s0 192.168.123.1 2> /dev/null
	pingLAN=$?

	${PING} enp7s0 1.1.1.1 2> /dev/null
	pingWAN=$?

	if [ $pingLAN -eq 0 ] && [ $pingWAN -eq 0 ]; then
		# LAN UP, WAN UP
		printStatus 1
	elif [ $pingLAN -ne 0 ] && [ $pingWAN -eq 0 ]; then
	    # LAN DOWN, WAN UP
		printStatus 2
	elif [ $pingLAN -eq 0 ] && [ $pingWAN -ne 0 ]; then
		# LAN UP, WAN DOWN
		printStatus 3
	elif [ $pingLAN -ne 0 ] && [ $pingWAN -ne 0 ]; then
		# LAN DOWN, WAN DOWN
		printStatus 4
	fi

	sleep ${timeInterval}
done
