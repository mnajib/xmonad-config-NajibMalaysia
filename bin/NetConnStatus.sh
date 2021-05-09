#!/run/current-system/sw/bin/env bash
#
# Usage:
#	network-status <interfacename> <pingdestination>
#

ping_interface() {
    # Max value of losted packages in %
    MAX_PACKETS_LOST=80
    PACKETS_COUNT=10
    #PACKETS_LOST=$(ping -c $PACKETS_COUNT -I $1 $2 |grep % | awk '{print $7}')
    PACKETS_LOST=$(ping -c $PACKETS_COUNT -I $1 $2 | grep '% packet loss' | awk '{print $6}')
    if ! [ -n "$PACKETS_LOST" ] || [ "$PACKETS_LOST" == "100%" ];
    then
        # 100% failed
        #echo "XXX1: 100% FAILED. Return 1."
        echo "1"
        return 1
    else
        if [ "${PACKETS_LOST}" == "0%" ];
        then
            #ping is OK
            #echo "XXX2: Ping is OK. Return 0."
            echo "0"
            return 0
        else
            # Real value of losted packets between 0 and 100%
            REAL_PACKETS_LOST=$(echo $PACKETS_LOST | sed 's/.$//')
            if [[ ${REAL_PACKETS_LOST} -gt ${MAX_PACKETS_LOST} ]];
            then
                #echo "Network connection status: Failed. Lost more then limit."
                #echo "XXX3: Network Connection is FAILED with ${PACKETS_LOST} packets lost. Return 1."
                echo "1"
                return 1
            else
                #echo "Network connection status: OK."
                #echo "XXX4: Network connection is still OK with ${PACKETS_LOST} packets lost. Return 0."
                echo "0"
                return 0
            fi
        fi
    fi
}

#ping_interface enp7s0 192.168.1.1
#ping_interface enp7s0 1.1.1.1
#ping_interface ${1} ${2}
