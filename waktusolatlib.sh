#!/usr/bin/env bash

#
#  Get waktu solat formated to be use by xmobar
#
#  by Muhammad Najib Bin Ibrahim <mnajib@gmail.com>
#
#  Usage:
#      waktusolat-putrajaya-hbar
#

#
#. waktusolatlib.sh

FILE1=/tmp/${USER}-wsp1         # source data file
FILE2=/tmp/${USER}-wsp2         # one-line result waktu solat formated for xmobar
FILE3=/tmp/${USER}-wsp1.bak     # backup good source data file
LOG=/tmp/${USER}-wsp.log        # for logging

ONELINE=""
NAMASOLAT=()
MASASOLAT=()
KAWASAN=""
ZON="" # SGR01 (Gombak, Petaling, Sepang, Hulu Langat, Hulu Selangor, S.Alam), WLY01
BEARING=""
TITLE=""
ERROR=false
HDATE=""
MDATE=""
MDATETIME=""
DAY=""
STATUS=""
HMONTHNUMBER=""
MMONTHNUMBER=""
HMONTHFULLNAME=""
MMONTHFULLNAME=""

LOGMODE="NORMAL"
#LOGMODE="DEBUG"

#
# Usage:
#     log INFO "Length error."
#     log DEBUG "Start fetchData()."
#
log () {
    local logmode=$1
    local logstring=$2
    #local logfile=$3

    # Will use global var: LOG, LOGMODE
    if [ "$LOGMODE" = "DEBUG" ]; then
        # For debugging purpose, log all information
        echo "${logmode}: ${logstring}" >> $LOG
    elif [ "$LOGMODE" = "NORMAL" ] && [ "$logmode" = "ERROR" ]; then
        # Normally, just log general information
        echo "${logmode}: ${logstring}" >> $LOG
    fi
}

read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
    }

fetchData (){
    log DEBUG "Start fetchData()"
    curl "https://www.e-solat.gov.my/index.php?r=esolatApi/TakwimSolat&period=today&zone=WLY01" 2>/dev/null | sed "s/^.*\[{//g" | sed "s/}]//g" | sed 's/}$//g'  | sed 's/$/\n/g' | tr "," "\n" | sed 's/\":\"/\",\"/g' | sed 's/"//g' > $FILE1
    log DEBUG "End fetchData()"
}

function fetchDataZone () {
    log DEBUG "Start fetchDataZone()"
    #curl "https://www.e-solat.gov.my/index.php?r=esolatApi/TakwimSolat&period=today&zone=${zone}" 2>/dev/null | sed "s/^.*\[{//g" | sed "s/}]//g" | sed 's/}$//g'  | sed 's/$/\n/g' | tr "," "\n" | sed 's/\":\"/\",\"/g' | sed 's/"//g' > $FILE1

    # Ignore SSL/cert error ... ???
    curl -k "https://www.e-solat.gov.my/index.php?r=esolatApi/TakwimSolat&period=today&zone=${zone}" 2>/dev/null | sed "s/^.*\[{//g" | sed "s/}]//g" | sed 's/}$//g'  | sed 's/$/\n/g' | tr "," "\n" | sed 's/\":\"/\",\"/g' | sed 's/"//g' > $FILE1

    log DEBUG "End fetchDataZone()"
}

getOldGoodFetchData(){
    log DEBUG "Start getOldGoodFetchData()"
    log DEBUG "Get previous backup fetched source from file ${FILE3}"
    cat $FILE3 > $FILE1
    log DEBUG "End getOldGoodFetchData()"
    }

simulateFailFetchData() {
    log DEBUG "Start simulateFailFetchData()"
    echo "" > $FILE1
    log DEBUG "End simulateFailFetchData()"
    }

simulateFetchData(){
    cat > $FILE1 << EOL
hijri,1441-09-07
date,30-Apr-2020
day,Thursday
imsak,05:44:00
fajr,05:54:00
syuruk,07:03:00
dhuhr,13:13:00
asr,16:31:00
maghrib,19:20:00
isha,20:31:00
EOL
    }

resetData() {
    log DEBUG "Start resetData()"

    ONELINE=""
    NAMASOLAT=()
    MASASOLAT=()
    KAWASAN=""
    TITLE=""

    HDATE=""
    MDATE=""
    DAY=""

    log DEBUG "End resetData()"
    }

# Usage:
#    namaBulanH $nomborBulan
#    namaBulanH "02"
namaBulanH(){
    noBulanH="$1"

    case "$noBulanH" in
        "01")
            echo "Muharam"
            ;;
        "02")
            echo "Safar"
            ;;
        "03")
            echo "Rabiulawal"
            ;;
        "04")
            echo "Rabiulakhir"
            ;;
        "05")
            echo "Jamadilawal"
            ;;
        "06")
            echo "Jamadilakhir"
            ;;
        "07")
            echo "Rejab"
            ;;
        "08")
            echo "Saaban"
            ;;
        "09")
            echo "Ramadan"
            ;;
        "10")
            echo "Syawal"
            ;;
        "11")
            echo "Zulkaedah"
            ;;
        "12")
            echo "Zulhijjah"
            ;;
        *)
            echo "eh"
            ;;
    esac
}

namaBulanM(){
    noBulanM="$1"

    case "$noBulanM" in
        "01")
            echo "January"
            ;;
        "02")
            echo "February"
            ;;
        "03")
            echo "March"
            ;;
        "04")
            echo "April"
            ;;
        "05")
            echo "May"
            ;;
        "06")
            echo "June"
            ;;
        "07")
            echo "July"
            ;;
        "08")
            echo "August"
            ;;
        "09")
            echo "September"
            ;;
        "10")
            echo "October"
            ;;
        "11")
            echo "November"
            ;;
        "12")
            echo "December"
            ;;
        *)
            echo "eh"
            ;;
    esac
}

nomHari(){
	namaHari="$1"

	case "$namaHari" in
		"Sunday")
			echo "1"
			;;
		"Monday")
			echo "2"
			;;
		"Tuesday")
			echo "3"
			;;
		"Wednesday")
			echo "4"
			;;
		"Thursday")
			echo "5"
			;;
		"Friday")
			echo "6"
			;;
		"Saturday")
			echo "7"
			;;
		*)
			echo "eh"
			;;
	esac
}

namaHariBM(){
	nomHari="$1"

	#...
}

namaHariBI(){
	nomHari="$1"

	#...
}

extractData() {
    log DEBUG "Start extractData()"

    BAKIFS="$IFS"
    IFS=","
    while read NAME VALUE; do
        case "${NAME}" in
            'status')
                STATUS="$VALUE"
                ;;
            'serverTime')
                MDATETIME="$VALUE"
                ;;
            'zone')
                ZON="$VALUE"
                ;;
            'bearing')
                BEARING="$VALUE"
                ;;
            'hijri')
                HDATE="$VALUE"
                ;;
            "date")
                MDATE="$VALUE"
                ;;
            "day")
                DAY="$VALUE"
                ;;
            "imsak")
                NAMASOLAT+=("Imsak")
                #NAMASOLAT+=("Imsk")
                MASASOLAT+=(`echo "$VALUE" | sed 's/:[0-9][0-9]$//g'`)
                ;;
            "fajr")
                NAMASOLAT+=("Subuh")
                #NAMASOLAT+=("Subh")
                MASASOLAT+=(`echo "$VALUE" | sed 's/:[0-9][0-9]$//g'`)
                ;;
            "syuruk")
                NAMASOLAT+=("Syuruk")
                #NAMASOLAT+=("Syur")
                MASASOLAT+=(`echo "$VALUE" | sed 's/:[0-9][0-9]$//g'`)
                ;;
            "dhuhr")
                NAMASOLAT+=("Zohor")
                #NAMASOLAT+=("Zohr")
                MASASOLAT+=(`echo "$VALUE" | sed 's/:[0-9][0-9]$//g'`)
                ;;
            "asr")
                NAMASOLAT+=("Asar")
                MASASOLAT+=(`echo "$VALUE" | sed 's/:[0-9][0-9]$//g'`)
                ;;
            "maghrib")
                NAMASOLAT+=("Maghrib")
                #NAMASOLAT+=("Mghr")
                MASASOLAT+=(`echo "$VALUE" | sed 's/:[0-9][0-9]$//g'`)
                ;;
            "isha")
                NAMASOLAT+=("Isyak")
                #NAMASOLAT+=("Isyk")
                MASASOLAT+=(`echo "$VALUE" | sed 's/:[0-9][0-9]$//g'`)
                ;;
            *)
                echo "" > /dev/null
                #echo "eh"
                ;;
        esac

    done < "$FILE1"
    IFS="$BAKIFS"

    log DEBUG "End extractData()"
    }

# XXX: may need revice
setBlankDataToArray() {
    log DEBUG "Start setBlankDataToArray"
    resetData

    ONELINE="Waktu Solat Putrajaya Hari Ini"
    ONELINE+="  (00-00-0000 00:00:00)   <fc=#ffffff,#ff4d4d>OLD</fc>   "
    KAWASAN="Kuala Lumpur,Putrajaya"
    NAMASOLAT=(Imsak Subuh Syuruk Zohor Asar Maghrib Isyak)
    #NAMASOLAT=(Imsk Subh Syur Zohr Asar Mghr Isyk)
    MASASOLAT=("00:00" "00:00" "00:00" "00:00" "00:00" "00:00" "00:00")
    log DEBUG "End setBlankDataToArray"

    HDATE="0000-00-00"
    MDATE="0000-xxx-00"
    DAY="xxxxxxxxx"
    }

# NAMASOLAT=(Imsak Subuh Syuruk Zohor Asar Maghrib Isyak)
# NAMASOLAT[0]="Imsak"
# NAMASOLAT[1]="Subuh"
# MASASOLAT=("00:00" "00:00" "00:00" "00:00" "00:00" "00:00" "00:00")
checkData() {
    log DEBUG "Start checkData()"

    arrayLength=0
    arrayLength=${#NAMASOLAT[@]}
    if (( $arrayLength == 7 )) ; then
        log DEBUG "Array length as we needed : $arrayLength"
        if [ "${NAMASOLAT[0]}" != "Imsak" ] || [ "${NAMASOLAT[1]}" != "Subuh" ] || [ "${NAMASOLAT[2]}" != "Syuruk" ] || [ "${NAMASOLAT[3]}" != "Zohor" ] || [ "${NAMASOLAT[4]}" != "Asar" ] || [ "${NAMASOLAT[5]}" != "Maghrib" ] || [ "${NAMASOLAT[6]}" != "Isyak" ]; then
        #if [ "${NAMASOLAT[0]}" != "Imsk" ] || [ "${NAMASOLAT[1]}" != "Subh" ] || [ "${NAMASOLAT[2]}" != "Syur" ] || [ "${NAMASOLAT[3]}" != "Zohr" ] || [ "${NAMASOLAT[4]}" != "Asar" ] || [ "${NAMASOLAT[5]}" != "Mghr" ] || [ "${NAMASOLAT[6]}" != "Isyk" ]; then
            log DEBUG "ERROR #001: Nama waktu solat tak sama"
            ERROR=true
        else
            log DEBUG "No error detected."
            # XXX:
            ERROR=false
        fi
    else
        log DEBUG "ERROR #002: Array length NOT as we expacted : $arrayLength"
        ERROR=true
    fi

    log DEBUG "End chechData()"
    }

doBackup() {
    log DEBUG "Start doBackup()"
    log DEBUG "Do backup fetch source file to ${FILE3}"
    cat $FILE1 > $FILE3
    log DEBUG "End doBackup()"
    }

printWaktuSolatForHtml() {
    #log DEBUG "Start qqfy665..."

    local out=""
    local mDate=""
    local mTime=""

    local cPre="\e["
    local cPost="\e[0m"

    local cGreen="32m"
    local cLightGreen="1;32m"
    local cBlue="34m"
    local cLightBlue="1;34m"
    local cPurple="35m"
    local cLightPurple="1;35m"
    local cCyan="36m"
    local cLightCyan="1;36m"
    local cYellow="33m"
    local cLightYellow="1;33m"
    #local cPink="ff66ff"
    local cWhite="1;37m"
    local cLightGray="37m"
    local cBlack="30m"

    out+="${cPre}${cPurple}Putrajaya${cPost}"                 # Area/Zone

    out+=" $DAY"                                 # Day

    HMONTHNUMBER=`echo "${HDATE}" | awk -F- '{print $2}'`
    HMONTHFULLNAME=`namaBulanH ${HMONTHNUMBER}`
    out+=" ${cPre}${cGreen}(${HMONTHFULLNAME})${HDATE}${cPost}"             # Hijrah date

    mDate=`echo "${MDATETIME}" | sed 's/\ .*$//g'`
    mTime=`echo "${MDATETIME}" | sed 's/^.*\ //g'`

    MMONTHNUMBER=`echo "${mDate}" | awk -F- '{print $2}'`
    MMONTHFULLNAME=`namaBulanM ${MMONTHNUMBER}`
    #MMONTHFULLNAME="January" # XXX
    out+=" ${cPre}${cCyan}(${MMONTHFULLNAME})${mDate}${cPost}"              # Masihi date

    out+=" ${cPre}${cYellow}${mTime}${cPost}"               # Time

    out+=" "

    if $ERROR; then
        out+=" <fc=#ffffff,#ff4d4d> OLD </fc>  "        # Mark old data
    else
        out+="      "
    fi

    out+="\n"
    for i in "${!NAMASOLAT[@]}"; do
        out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    done

    echo -en "${out}\n"
    #ONELINE="${out}"

    log DEBUG "End formatWaktuSolatForXmobar()"
    }

printWaktuSolatForCliType1() {
    #log DEBUG "Start qqfy665..."

    local out=""
    local mDate=""
    local mTime=""

    local cPre="\e["
    local cPost="\e[0m"

    local cGreen="32m"
    local cLightGreen="1;32m"
    local cBlue="34m"
    local cLightBlue="1;34m"
    local cPurple="35m"
    local cLightPurple="1;35m"
    local cCyan="36m"
    local cLightCyan="1;36m"
    local cYellow="33m"
    local cLightYellow="1;33m"
    #local cPink="ff66ff"
    local cWhite="1;37m"
    local cLightGray="37m"
    local cBlack="30m"

    #out+="${cPre}${cPurple}Putrajaya${cPost}"                 # Area/Zone
    out+="${cPre}${cPurple}${ZON}${cPost}"                 # Area/Zone

    out+=" $DAY"                                 # Day

    HMONTHNUMBER=`echo "${HDATE}" | awk -F- '{print $2}'`
    HMONTHFULLNAME=`namaBulanH ${HMONTHNUMBER}`
    out+=" ${cPre}${cGreen}(${HMONTHFULLNAME})${HDATE}${cPost}"             # Hijrah date

    mDate=`echo "${MDATETIME}" | sed 's/\ .*$//g'`
    mTime=`echo "${MDATETIME}" | sed 's/^.*\ //g'`

    MMONTHNUMBER=`echo "${mDate}" | awk -F- '{print $2}'`
    MMONTHFULLNAME=`namaBulanM ${MMONTHNUMBER}`
    #MMONTHFULLNAME="January" # XXX
    out+=" ${cPre}${cCyan}(${MMONTHFULLNAME})${mDate}${cPost}"              # Masihi date

    out+=" ${cPre}${cYellow}${mTime}${cPost}"               # Time

    out+=" "

    if $ERROR; then
        out+=" <fc=#ffffff,#ff4d4d> OLD </fc>  "        # Mark old data
    else
        out+="      "
    fi

    out+="\n"
    #for i in "${!NAMASOLAT[@]}"; do
    #    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    #done
    i=5
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=6
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=0
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=1
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=2
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=3
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=4
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "

    echo -en "${out}\n"
    #ONELINE="${out}"

    log DEBUG "End formatWaktuSolatForXmobar()"
    }

formatWaktuSolatForXmobar() {
    log DEBUG "Start formatWaktuSolatForXmobar()"

    local out=""
    local mDate=""
    local mTime=""

    #local cPre="<fc=#"
    #local cPost="\e[0m"

    local cGreen="00ff00"
    local cBlue="00ffff"
    local cYellow="ffff00"
    local cPink="ff66ff"
    local cWhite="ffffff"

    mDate=`echo "${MDATETIME}" | sed 's/\ .*$//g'`
    mTime=`echo "${MDATETIME}" | sed 's/^.*\ //g'`
    MMONTHNUMBER=`echo "${mDate}" | awk -F- '{print $2}'`
    MMONTHFULLNAME=`namaBulanM ${MMONTHNUMBER}`
    HMONTHNUMBER=`echo "${HDATE}" | awk -F- '{print $2}'`
    HMONTHFULLNAME=`namaBulanH ${HMONTHNUMBER}`

    out+=" "
    out+="$DAY"                                                                 # Day in English

    out+=" <fc=#${cBlue}>${MMONTHFULLNAME} </fc><fc=#${cYellow}>${mDate}</fc>"   # Masihi date

    out+=" <fc=#${cWhite}>${mTime}</fc>"                                       # Time
    #out+=" "

    if $ERROR; then
        out+=" <fc=#ffffff,#ff4d4d> OLD </fc>  "                                # Mark old data
    else
        out+="      "
    fi

    #out+="<fc=#${cPink}>Putrajaya</fc>"                                        # Area/Zone
    out+="<fc=#${cPink}>${zone}</fc>"                                           # Area/Zone

    #out+=" <fc=#${cGreen}>(${HMONTHFULLNAME})${HDATE}</fc>"                    # Hijrah date
    out+=" <fc=#${cBlue}>${HMONTHFULLNAME} </fc><fc=#${cYellow}>${HDATE}</fc>"   # Hijrah date

    out+=" "

    #for i in "${!NAMASOLAT[@]}"; do
    #    #out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff> ${MASASOLAT[$i]} </fc> "
    #    out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff>${MASASOLAT[$i]}</fc> "
    #done
    i=5
    out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff>${MASASOLAT[$i]}</fc> "
    i=6
    out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff>${MASASOLAT[$i]}</fc> "
    i=0
    out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff>${MASASOLAT[$i]}</fc> "
    i=1
    out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff>${MASASOLAT[$i]}</fc> "
    i=2
    out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff>${MASASOLAT[$i]}</fc> "
    i=3
    out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff>${MASASOLAT[$i]}</fc> "
    i=4
    out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff>${MASASOLAT[$i]}</fc>"

    #echo -en "${out}\n"
    ONELINE="${out}"

    log DEBUG "End formatWaktuSolatForXmobar()"
    }

formatWaktuSolatForXmobarOld() {
    log DEBUG "Start formatWaktuSolatForXmobar()"

    local out=""
    local mDate=""
    local mTime=""
    local cGreen="00ff00"
    local cBlue="00ffff"
    local cYellow="ffff00"
    local cPink="ff66ff"
    local cWhite="ffffff"

    out+="<fc=#${cPink}>Putrajaya</fc>"                 # Area/Zone
    out+=" (H)<fc=#${cGreen}>${HDATE}</fc>"             # Hijrah date
    mDate=`echo "${MDATETIME}" | sed 's/\ .*$//g'`
    mTime=`echo "${MDATETIME}" | sed 's/^.*\ //g'`
    out+=" (M)<fc=#${cBlue}>${mDate}</fc>"              # Masihi date
    out+=" <fc=#${cYellow}>${mTime}</fc>"               # Time
    #out+=" Hari: $DAY"                                 # Day
    out+=" "

    if $ERROR; then
        out+=" <fc=#ffffff,#ff4d4d> OLD </fc>  "        # Mark old data
    else
        out+="      "
    fi

    for i in "${!NAMASOLAT[@]}"; do
        out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff> ${MASASOLAT[$i]} </fc> "
    done

    #echo -en "${out}\n"
    ONELINE="${out}"

    log DEBUG "End formatWaktuSolatForXmobar()"
    }

printNewWaktuSolat() {
    echo "${ONELINE}"
    #echo -ne "${ONELINE}" > $FILE2
    }

printOldWaktuSolat() {
    #echo -ne "TODO: Print old waktu solat.\n"

    # Get old waktu solat from file
    #...

    # Change coloring or add warning mark for 'OLD' data
    #...sed ...

    # XXX: Test with fake old waktu solat
    #echo "<23-04-2020 16:08:50>         <fc=#00ff00>Imsak</fc> <fc=#ffffff>05:46</fc> <fc=#00ff00>Subuh</fc> <fc=#ffffff>05:56</fc> <fc=#00ff00>Syuruk</fc> <fc=#ffffff>07:04</fc> <fc=#00ff00>Zohor</fc> <fc=#ffffff>13:14</fc> <fc=#00ff00>Asar</fc> <fc=#ffffff>16:29</fc> <fc=#00ff00>Maghrib</fc> <fc=#ffffff>19:20</fc> <fc=#00ff00>Isyak</fc> <fc=#ffffff>20:31</fc>"
    echo "Waktu Solat Putrajaya Hari Ini <23-04-2020 16:08:50>         <fc=#999999>Imsak</fc><fc=#cc6600,#663300>05:46</fc> <fc=#999999>Subuh</fc><fc=#cc6600,#663300>05:56</fc> <fc=#999999>Syuruk</fc><fc=#cc6600,#663300>07:04</fc> <fc=#999999>Zohor</fc><fc=#cc6600,#663300>13:14</fc> <fc=#999999>Asar</fc><fc=#cc6600,#663300>16:29</fc> <fc=#999999>Maghrib</fc><fc=#cc6600,#663300>19:20</fc> <fc=#999999>Isyak</fc><fc=#cc6600,#663300>20:31</fc>"
    }

printEmptyWaktuSolat() {
    echo "Waktu Solat Putrajaya Hari Ini <00-00-0000 00:00:00>         <fc=#00ff00>Imsak</fc><fc=#ff9933,#663300> 00:00 </fc> <fc=#00ff00>Subuh</fc><fc=#ff9933,#663300> 00:00 </fc> <fc=#00ff00>Syuruk</fc><fc=#ff9933,#663300> 00:00 </fc> <fc=#00ff00>Zohor</fc><fc=#ff9933,#663300> 00:00 </fc> <fc=#00ff00>Asar</fc><fc=#ff9933,#663300> 00:00 </fc> <fc=#00ff00>Maghrib</fc><fc=#ff9933,#663300> 00:00 </fc> <fc=#00ff00>Isyak</fc><fc=#ff9933,#663300> 00:00 </fc>"
    #echo "<00-00-0000 00:00:00>         [<fc=#00ff00>Imsak</fc><fc=#ff9933,#663300> 00:00 </fc>] [<fc=#00ff00>Subuh</fc><fc=#ff9933,#663300> 00:00 </fc>] [<fc=#00ff00>Syuruk</fc><fc=#ff9933,#663300> 00:00 </fc>] [<fc=#00ff00>Zohor</fc><fc=#ff9933,#663300> 00:00 </fc>] [<fc=#00ff00>Asar</fc><fc=#ff9933,#663300> 00:00 </fc>] [<fc=#00ff00>Maghrib</fc><fc=#ff9933,#663300> 00:00 </fc>] [<fc=#00ff00>Isyak</fc><fc=#ff9933,#663300> 00:00 </fc>]"
    }
