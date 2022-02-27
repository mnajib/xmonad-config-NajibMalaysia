#!/usr/bin/env bash

PING=~/.xmonad/bin/NetConnStatus.sh
#LOGFILE=~/.xmonad/var/${USER}-NetConnStatus.log # date_time, LAN_status, WAN_status

INTERFACE=enp7s0	# XXX: Not really in use

# IP to run ping test
LANIP='192.168.123.157' # XXX: Too specific, not usefull with other LAN network. mahirah OR tv OR khawlah OR khadijah
WANIP='1.1.1.1'
GWIP='192.168.123.1'	# XXX: Not really in use

# Network status (0 up; 1 down)
LSTATUS=1
WSTATUS=1
GSTATUS=1

# UP
FgColor1="#181715"
BgColor1="#58C5F1"
# DOWN
FgColor2="#646464"
BgColor2="#ff0000"

timeInterval=2 #5 #10 #15 60

function f_gwip {
	local gwip=$(ip route ls | grep "^default" | sed 's/^default via //g' | sed 's/ dev.*$//g')
	echo $gwip
}

function f_ping {
	local ping=$1
	local interface=$2
	local ip=$3

	${ping} ${interface} ${ip} 2> /dev/null
	local status=$?
	
	echo $status
}

function f_coloringNetStatus {
	local net=$1
	local status=$2

	#local fgColor=$1
	#local bgColor=$2

	if [ $status -eq 0 ]; then
		echo "<fc=${FgColor1},${BgColor1}> ${net}</fc>"
	else
		echo "<fc=${FgColor2},${BgColor2}> ${net}</fc>"
	fi
}

function f_printNetsStatus {
	local lStatus=$1
	local wStatus=$2
	local gStatus=$3

	local lColoredStatus=$(f_coloringNetStatus LAN $lStatus)
	local wColoredStatus=$(f_coloringNetStatus WAN $wStatus)
	local gColoredStatus=$(f_coloringNetStatus GW $gStatus)

	echo "${lColoredStatus},${wColoredStatus},${gColoredStatus}"
}

while true; do
	# Get network status
	LSTATUS=$(f_ping ${PING} ${INTERFACE} ${LANIP})
	WSTATUS=$(f_ping ${PING} ${INTERFACE} ${WANIP})
	#GSTATUS=$(f_ping ${PING} ${INTERFACE} ${GWIP})
	GSTATUS=$(f_ping ${PING} ${INTERFACE} $(f_gwip))

	# Print network status
	f_printNetsStatus $GSTATUS $LSTATUS $WSTATUS

	# Sleep before loop
	sleep ${timeInterval}
done
