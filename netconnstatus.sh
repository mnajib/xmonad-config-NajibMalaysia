#!/run/current-system/sw/bin/env bash

. ~/.xmonad/bin/NetConnStatus.sh

s=""
FgColor1="#181715"
BgColor1="#58C5F1"
FgColor2="#646464"
BgColor2="#ff0000"
#timeInterval=`echo "60 * 2" | bc` # every 2 minutes
timeInterval=60

while true; do
	#date
	s=""
	pingLAN=$(ping_interface enp7s0 192.168.123.1)
	#pingLAN2=$(ping_interface enp7s0 192.168.123.77)
	pingWAN=$(ping_interface enp7s0 1.1.1.1)

	# Check LAN
	if [ $pingLAN -eq 0 ]; then
		s+="<fc=${FgColor1},${BgColor1}>LAN</fc>"
		#echo "LAN: OK"
	else
		s+="<fc=${FgColor2},${BgColor2}>LAN</fc>"
		#echo "LAN: KO"
	fi

	# Check WAN
	if [ $pingWAN -eq 0 ]; then
		s+=",<fc=${FgColor1},${BgColor1}>WAN</fc>"
		#echo "WAN: OK"
	else
		s+=",<fc=${FgColor2},${BgColor2}>WAN</fc>"
		#echo "WAN: KO"
	fi

	echo "${s}"
	#date

	sleep ${timeInterval}
done
