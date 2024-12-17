#!/usr/bin/env bash
#
# Usage:
#	network-status <interfacename> <pingdestination>
#

ping_interface() {
    # Max value of losted packages in %
    PACKETS_LOST_TRESHOLD=80
    PACKETS_COUNT=3 #10
    PACKETS_LOST=0

    PACKETS_LOST=$(ping -q -c $PACKETS_COUNT $2 2> /dev/null | grep '% packet loss' | sed 's/, /\n/g' | grep 'loss' | sed 's/\%.*$//g')

    if [ "$PACKETS_LOST" == "" ]; then
	#echo "FAILED. Return 1."
        return 1
    else
        if (( ${PACKETS_LOST} > ${PACKETS_LOST_TRESHOLD} )); then
           #echo "Network Connection is FAILED with ${PACKETS_LOST} packets lost. Return 2."
           #echo 1
            return 2
        else
            #echo "Network is fine. Return 0."
            return 0
        fi
    fi
}

#ping_interface enp7s0 192.168.1.1
#ping_interface enp7s0 1.1.1.1
ping_interface ${1} ${2}
