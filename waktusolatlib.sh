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
#LOGMODE="INFO"
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
    elif [ "$LOGMODE" = "INFO" ] && [ "$logmode" = "INFO" ]; then
        echo "${logmode}: ${logstring}" >> $LOG
    elif [ "$logmode" = "ERROR" ]; then
        echo "${logmode}: ${logstring}" >> $LOG
    fi
}

read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
    }

# NOTE:
#   To fetch:
#     https://www.e-solat.gov.my/index.php?r=esolatApi/xmlfeed&zon=SGR01
#     view-source:https://www.e-solat.gov.my/index.php?r=esolatApi/xmlfeed&zon=SGR01
#

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
namaBulanH() {
    local noBulanH="$1"

    local ntype="${2:-short}"
    #local ntype="${2:-long}"

    if [ "$ntype" = "long" ]; then
      ntype="long"
    fi

    case "$noBulanH" in
        "01")
            if [ "$ntype"  = "long" ]; then
              echo "Muharam"
            else
              echo "Mhram"
            fi
            ;;
        "02")
            #echo "Safar"
            if [ "$ntype"  = "long" ]; then
              echo "Safar"
            else
              echo "Safar"
            fi
            ;;
        "03")
            #echo "Rabiulawal"
            if [ "$ntype"  = "long" ]; then
              echo "Rabiulawal"
            else
              echo "Rbawl"
            fi
            ;;
        "04")
            #echo "Rabiulakhir"
            if [ "$ntype"  = "long" ]; then
              echo "Rabiulakhir"
            else
              echo "Rbakh"
            fi
            ;;
        "05")
            #echo "Jamadilawal"
            if [ "$ntype"  = "long" ]; then
              echo "Jamadilawal"
            else
              echo "Jmawl"
            fi
            ;;
        "06")
            #echo "Jamadilakhir"
            if [ "$ntype"  = "long" ]; then
              echo "Jamadilakhir"
            else
              echo "Jmakh"
            fi
            ;;
        "07")
            echo "Rejab"
            # XXX: test
            #if [ "$ntype"  = "long" ]; then
            #  echo "REJAB"
            #else
            #  echo "ReJaB"
            #fi
            ;;
        "08")
            #echo "Saaban"
            if [ "$ntype"  = "long" ]; then
              echo "Saaban"
            else
              echo "Sy3bn"
            fi
            ;;
        "09")
            #echo "Ramadan"
            if [ "$ntype"  = "long" ]; then
              echo "Ramadan"
            else
              echo "Rmdan"
            fi
            ;;
        "10")
            #echo "Syawal"
            if [ "$ntype"  = "long" ]; then
              echo "Syawal"
            else
              echo "Syawl"
            fi
            ;;
        "11")
            #echo "Zulkaedah"
            if [ "$ntype"  = "long" ]; then
              echo "Zulkaedah"
            else
              echo "Zlkdh"
            fi
            ;;
        "12")
            #echo "Zulhijjah"
            if [ "$ntype"  = "long" ]; then
              echo "Zulhijjah"
            else
              echo "Zlhjh"
            fi
            ;;
        *)
            echo "eh"
            ;;
    esac
}

namaBulanM(){
    local noBulanM="$1"

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

#   nomNextHari <nomborHari>
# Usage example
#   nomNextHari 8
nomNextHari(){
  local currentDay=$1
  local nextDay=0 # 1=sunday, 2=monday, 3=tuesday, ...

  nextDay=$(( $1 + 1 ))
  if [ "$nextDay" -eq "8" ]; then
    nextDay=1
  fi

  echo $nextDay
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

namaHariAR(){
  local nomHari="$1"

  case "$nomHari" in
    "1")
      echo "al-a-had"
      ;;
    "2")
      echo "al-ith-neen"
      ;;
    "3")
      echo "ath-thu-la-tha'"
      ;;
    "4")
      echo "al-ar-bi-3a'"
      ;;
    "5")
      echo "al-kha-mees"
      ;;
    "6")
      echo "al-ju-ma-3a"
      ;;
    "7")
      echo "as-sabt"
      ;;
    *)
      echo "eh"
      ;;
  esac
}

namaHariBM(){
  local nomHari="$1"

  case "$nomHari" in
    1)
      echo "Ahad"
      ;;
    2)
      echo "Isnin"
      ;;
    3)
      echo "Selasa"
      ;;
    4)
      echo "Rabu"
      ;;
    5)
      echo "Khamis"
      ;;
    6)
      echo "Jumaat"
      ;;
    7)
      echo "Sabtu"
      ;;
  esac
}

namaHariBI(){
  local nomHari="$1"

  case "$nomHari" in
    1)
      echo "Sunday"
      ;;
    2)
      echo "Monday"
      ;;
    3)
      echo "Tuesday"
      ;;
    4)
      echo "Wednesday"
      ;;
    5)
      echo "Thursday"
      ;;
    6)
      echo "Friday"
      ;;
    7)
      echo "Saturday"
      ;;
  esac
}

# Tak perlu ada
#namaNextHariBM(){
#  local nomHari=$1
#  local namaNextHariInBM=""
#
#  nomNextHari=$(${1}+1)
#  #echo "nomNextHari: $nomNextHari"
#  namaNextHariInBM=$(namaHariBM $nomNextHari)
#}

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

# Berasaskan hari/tarihk hijrah, bertukar hari pada waktu maghrib
printWaktuSolatForCliType1() {
    #log DEBUG "Start qqfy665..."

    local out=""
    local mDate=""
    local mTime=""

    local cPre="\e["
    local cPost="\e[0m"

    local cRed="97;41m"
    local cLightRed="01;05;37;41m"              #"1;97;41m"
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

    mDate=`echo "${MDATETIME}" | sed 's/\ .*$//g'`
    mTime=`echo "${MDATETIME}" | sed 's/^.*\ //g'`

    HMONTHNUMBER=`echo "${HDATE}" | awk -F- '{print $2}'`
    HMONTHFULLNAME=`namaBulanH ${HMONTHNUMBER}`
    MMONTHNUMBER=`echo "${mDate}" | awk -F- '{print $2}'`
    MMONTHFULLNAME=`namaBulanM ${MMONTHNUMBER}`
    #MMONTHFULLNAME="January" # XXX

    local nomborHari=`nomHari $DAY`
    local hariInBM=`namaHariBM $nomborHari`

    #--------------------------------------------------------------------------
    out+="Jadual Waktu Solat untuk "
    #out+="${cPre}${cPurple}Putrajaya${cPost}"                 # Area/Zone
    out+="${cPre}${cPurple}${ZON}${cPost}"                 # Area/Zone

    out+=" ${cPre}${cYellow}$hariInBM${cPost}"                                 # Day
    out+=" ${cPre}${cGreen}${HMONTHFULLNAME} ${HDATE}${cPost}"             # Hijrah date

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
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}"

    #--------------------------------------------------------------------------
    #out+="\n"
    out+="\nThis data was downloaded on ${cPre}${cYellow}$DAY${cPost}"                                 # Day
    out+=" ${cPre}${cCyan}${MMONTHFULLNAME} ${mDate}${cPost}"              # Masihi date
    out+=" ${cPre}${cYellow}${mTime}${cPost}"               # Time
    out+=" from www.e-solat.gov.my"
    out+=" "
    #out+="["
    if $ERROR; then
    #if false; then
    #if true; then
        out+="${cPre}${cLightRed}"
        out+="!!! WARNING:OLD !!!"
        out+="${cPost}"                                        # Mark old data
    else
        out+="                   "
    fi
    #out+="]"

    #--------------------------------------------------------------------------
    # Return
    echo -en "${out}\n"
    #ONELINE="${out}"

    log DEBUG "End formatWaktuSolatForXmobar()"
    }

# Berasaskan hari/tarikh masihi, bertukar hari pada 12 tengah malam.
printWaktuSolatForCliType2() {
    #log DEBUG "Start qqfy665..."

    local out=""
    local mDate=""
    local mTime=""

    local cPre="\e["
    local cPost="\e[0m"

    local cRed="97;41m"
    local cLightRed="01;05;37;41m"              #"1;97;41m"
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

    mDate=`echo "${MDATETIME}" | sed 's/\ .*$//g'`
    mTime=`echo "${MDATETIME}" | sed 's/^.*\ //g'`

    HMONTHNUMBER=`echo "${HDATE}" | awk -F- '{print $2}'`
    HMONTHFULLNAME=`namaBulanH ${HMONTHNUMBER}`
    MMONTHNUMBER=`echo "${mDate}" | awk -F- '{print $2}'`
    MMONTHFULLNAME=`namaBulanM ${MMONTHNUMBER}`
    #MMONTHFULLNAME="January" # XXX

    local nomborHari=`nomHari $DAY`
    local hariInBM=`namaHariBM $nomborHari`

    #--------------------------------------------------------------------------
    out+="Jadual Waktu Solat untuk "
    #out+="${cPre}${cPurple}Putrajaya${cPost}"                 # Area/Zone
    out+="${cPre}${cPurple}${ZON}${cPost}"                 # Area/Zone

    out+=" ${cPre}${cYellow}$hariInBM${cPost}"                                 # Day
    out+=" ${cPre}${cGreen}${HMONTHFULLNAME} ${HDATE}${cPost}"             # Hijrah date

    out+="\n"
    #for i in "${!NAMASOLAT[@]}"; do
    #    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    #done
    out+="("
    i=5
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=6
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=0
    out+=")"
    out+="("
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=1
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=2
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=3
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    i=4
    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}"
    out+=")"

    #--------------------------------------------------------------------------
    #out+="\n"
    out+="\nThis data was downloaded on ${cPre}${cYellow}$DAY${cPost}"                                 # Day
    out+=" ${cPre}${cCyan}${MMONTHFULLNAME} ${mDate}${cPost}"              # Masihi date
    out+=" ${cPre}${cYellow}${mTime}${cPost}"               # Time
    out+=" from www.e-solat.gov.my"
    out+=" "
    #out+="["
    if $ERROR; then
    #if false; then
    #if true; then
        out+="${cPre}${cLightRed}"
        out+="!!! WARNING:OLD !!!"
        out+="${cPost}"                                        # Mark old data
    else
        out+="                   "
    fi
    #out+="]"

    #--------------------------------------------------------------------------
    # Return
    echo -en "${out}\n"
    #ONELINE="${out}"

    log DEBUG "End formatWaktuSolatForXmobar()"
    }

#startTxtSyle() {
#  echo ""
#}

#endTxtSyle() {
#  echo ""
#}

# Berasaskan hari/tarikh masihi, bertukar hari pada 12 tengah malam.
printWaktuSolatForCliType3() {
    log DEBUG "Start qqfy665gg..."

    local out=""
    local mDate=""
    local mTime=""

    local cPre="\e["
    local cPost="\e[0m"

    local cRed="97;41m"
    local cLightRed="01;05;37;41m"              #"1;97;41m"
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

    mDate=`echo "${MDATETIME}" | sed 's/\ .*$//g'`
    mTime=`echo "${MDATETIME}" | sed 's/^.*\ //g'`

    HMONTHNUMBER=`echo "${HDATE}" | awk -F- '{print $2}'`
    HMONTHFULLNAME=`namaBulanH ${HMONTHNUMBER}`
    MMONTHNUMBER=`echo "${mDate}" | awk -F- '{print $2}'`
    MMONTHFULLNAME=`namaBulanM ${MMONTHNUMBER}`
    #MMONTHFULLNAME="January" # XXX

    local nomborHari=`nomHari $DAY`
    #local nomborNextHari=$(( $nomborHari + 1 ))
    local nomborNextHari=`nomNextHari $nomborHari`
    local hariInBM=`namaHariBM $nomborHari`
    local nextHariInBM=`namaHariBM ${nomborNextHari}`
    log DEBUG "nomborHari = ${nomborHari}"
    log DEBUG "hariInBM = ${hariInBM}"
    log DEBUG "nomborNextHari = ${nomborNextHari}"
    log DEBUG "nextHariInBM = ${nextHariInBM}"

    #--------------------------------------------------------------------------
    out+="${cPre}${cPurple}${ZON}${cPost}"                 # Area/Zone
    #out+="\n"
    #for i in "${!NAMASOLAT[@]}"; do
    #    out+="${cPre}${cGreen}${NAMASOLAT[$i]}${cPost}${cPre}${cWhite} ${MASASOLAT[$i]}${cPost}, "
    #done
    out+=" T${cPre}${cYellow}${mTime}${cPost}"               # Time
    #--------------------------------------------------------------------------
    out+=" "
    #out+="["
    if $ERROR; then
    #if false; then
    #if true; then
        out+="${cPre}${cLightRed}"
        out+="OLD"
        out+="${cPost}"                                        # Mark old data
    else
        out+="   "
    fi
    #out+="]"
    out+=" "
    #--------------------------------------------------------------------------
    out+="("
    out+="${MMONTHFULLNAME:0:3} ${mDate} "              # Masihi date
    out+="${DAY:0:3}"                                 # Day
    out+=" ("
    out+="${HMONTHFULLNAME} ${HDATE} "             # Hijrah date
    out+="${hariInBM:0:3}"                                 # Day
    out+=" "
    i=0
    out+="${cPre}${cGreen}${NAMASOLAT[$i]:0:3}${cPost}${cPre}${cWhite}${MASASOLAT[$i]}${cPost},"
    i=1
    out+="${cPre}${cGreen}${NAMASOLAT[$i]:0:3}${cPost}${cPre}${cWhite}${MASASOLAT[$i]}${cPost},"
    i=2
    out+="${cPre}${cGreen}${NAMASOLAT[$i]:0:3}${cPost}${cPre}${cWhite}${MASASOLAT[$i]}${cPost},"
    i=3
    out+="${cPre}${cGreen}${NAMASOLAT[$i]:0:3}${cPost}${cPre}${cWhite}${MASASOLAT[$i]}${cPost},"
    i=4
    out+="${cPre}${cGreen}${NAMASOLAT[$i]:0:3}${cPost}${cPre}${cWhite}${MASASOLAT[$i]}${cPost}"
    out+=")"
    out+=" ("
    out+="${nextHariInBM:0:3} "
    i=5
    out+="${cPre}${cGreen}${NAMASOLAT[$i]:0:3}${cPost}${cPre}${cWhite}${MASASOLAT[$i]}${cPost},"
    i=6
    out+="${cPre}${cGreen}${NAMASOLAT[$i]:0:3}${cPost}${cPre}${cWhite}${MASASOLAT[$i]}${cPost}"
    out+=")"
    out+=")"


    #--------------------------------------------------------------------------
    # Return
    echo -en "${out}\n"
    #ONELINE="${out}"

    log DEBUG "End qqfy665gg..."
    }

formatWaktuSolatForXmobar_NEW_DEV_2024-11-29() {
#formatWaktuSolatForXmobar() {
    log DEBUG "Start formatWaktuSolatForXmobar()"

    local out=""
    local mDate=""
    local mTime=""

    #local cPre="<fc=#"
    #local cPost="\e[0m"

    local cBOLD="1"
    local cFGBLACK="30"
    local cFGGREY="90"
    local cFGRED="91"
    local cFGGREEN="32"
    local cFGBLUE="94"
    local cFGPURPLE="95"
    local cFGYELLOW="93"
    local cFGCYAN="36"
    local cFGWHITE="97"
    # Do not use bright color for background!
    local cBGWHITE="47"
    local cBGBLACK="40"
    local cBGGREEN="42"
    local cBGRED="41"

    local cRESET="\033[0m"
    local cDEFAULT="${cRESET}\033[${BOLD},${BGBLACK},${FGWHITE}m"
    local cKODZON="${cRESET}\033[${BOLD},${BGBLACK},${FGPURPLE}m"
    local cBULANHIJRAH="${cRESET}\033[${BOLD},${BGBLACK},${FGYELLOW}m"
    local cBULANMASIHI="${cRESET}\033[${BOLD},${BGBLACK},${FGYELLOW}m"
    local cTARIKHHIJRAH="${cRESET}\033[${BOLD},${BGBLACK},${FGBLUE}m"
    local cTARIKHMASIHI="${cRESET}\033[${BOLD},${BGBLACK},${FGBLUE}m"
    local cHARIMASIHI="${cRESET}\033[${BOLD},${BGBLACK},${FGYELLOW}m"
    local cHARIHIJRAH="${cRESET}\033[${BOLD},${BGBLACK},${FGYELLOW}m"
    local cNAMASOLAT="${cRESET}\033[${BOLD},${BGWHITE},${FGBLACK}m"
    local cWAKTUSOLAT="${cRESET}\033[${BOLD},${BGGREEN},${FGBLACK}m"
    local cKURUNGANHIJRAH="${cRESET}\033[${BOLD},${BGBLACK},${FGGREEN}m"
    local cKURUNGANMASIHI="${cRESET}\033[${BOLD},${BGBLACK},${FGBLUE}m"

    mDate=`echo "${MDATETIME}" | sed 's/\ .*$//g'`
    mTime=`echo "${MDATETIME}" | sed 's/^.*\ //g'`
    MMONTHNUMBER=`echo "${mDate}" | awk -F- '{print $2}'`
    MMONTHFULLNAME=`namaBulanM ${MMONTHNUMBER}`
    HMONTHNUMBER=`echo "${HDATE}" | awk -F- '{print $2}'`
    HMONTHFULLNAME=`namaBulanH ${HMONTHNUMBER}`

    local nomborHari=`nomHari $DAY`
    #local nomborNextHari=$(( $nomborHari + 1 ))
    local nomborNextHari=`nomNextHari $nomborHari`
    local hariInBM=`namaHariBM $nomborHari`
    local nextHariInBM=`namaHariBM $nomborNextHari`
    log DEBUG "nomborNexHari=${nomborNextHari}"
    log DEBUG "nextHariInBM=${nextHariInBM}"

    #out+="Downloaded from www.e-solat.gov.my on"
    #out+="Downloaded on"                                                        # Need shorten the overall text line, because Thinkpad X220 sceen not wide enough to display it
    out+="${cDEFAULT}On"                                                        # Need shorten the overall text line, because Thinkpad X220 sceen not wide enough to display it
    out+=" ${mDate}"                                        # Masihi date
    out+=" ${mTime};"                                       # Time
    #------------------
    out+=" "
    if $ERROR; then
        out+="${cRESET}\033[${cBOLD},${cBGRED},${cFGWHITE}mOLD"                                   # Mark old data
    else
        out+="   "
    fi
    out+=" "
    #------------------
    out+="${cDEFAULT}("
    out+="${cKODZONE}{zone}"                                           # Area/Zone
    out+=" ${cKURUNGANMASIHI}(${cBULANMASIHI}${MMONTHFULLNAME:0:3}"                         # Masihi month
    out+=" ${cTARIKHMASIHI}${mDate}"                                         # Masihi date
    out+=" ${cHARIMASIHI}${DAY:0:3}"                                     # Day in English

    out+=" ${cKURUNGANHIJRAH}("
    out+="${cBULANHIJRAH}${HMONTHFULLNAME}"
    out+=" ${cTARIKHHIJRAH}${HDATE}"                                         # Hijrah date
    out+=" ${cHARIHIJRAH}${hariInBM:0:3}"
    out+=" "

    #for i in "${!NAMASOLAT[@]}"; do
    #    #out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff> ${MASASOLAT[$i]} </fc> "
    #    out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff>${MASASOLAT[$i]}</fc> "
    #done
    i=0
    out+="${cNAMASOLAT}${NAMASOLAT[$i]:0:3}${cWAKTUSOLAT}${MASASOLAT[$i]} "
    i=1
    out+="${cNAMASOLAT}${NAMASOLAT[$i]:0:3}${cWAKTUSOLAT}${MASASOLAT[$i]} "
    i=2
    out+="${cNAMASOLAT}${NAMASOLAT[$i]:0:3}${cWAKTUSOLAT}${MASASOLAT[$i]} "
    i=3
    out+="${cNAMASOLAT}${NAMASOLAT[$i]:0:3}${cWAKTUSOLAT}${MASASOLAT[$i]} "
    i=4
    out+="${cNAMASOLAT}${NAMASOLAT[$i]:0:3}${cWAKTUSOLAT}${MASASOLAT[$i]}${cKURUNGANHIJRAH}) "
    out+="${cKURUNGANHIJRAH}(${cHARIHIJRAH}${nextHariInBM:0:3} "
    i=5
    out+="${cNAMASOLAT}${NAMASOLAT[$i]:0:3}${cWAKTUSOLAT}${MASASOLAT[$i]} "
    i=6
    out+="${cNAMASOLAT}${NAMASOLAT[$i]:0:3}${cWAKTUSOLAT}${MASASOLAT[$i]}${cKURUNGANHIJRAH})${cKURUNGANMASIHI})${cDEFAULT})"

    #echo -en "${out}\n"
    ONELINE="${out}"

    log DEBUG "End formatWaktuSolatForXmobar()"
    }

formatWaktuSolatForXmobar() {
#formatWaktuSolatForXmobar_with_HTML_color() {
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
    local cGrey="888888"

    mDate=`echo "${MDATETIME}" | sed 's/\ .*$//g'`
    mTime=`echo "${MDATETIME}" | sed 's/^.*\ //g'`
    MMONTHNUMBER=`echo "${mDate}" | awk -F- '{print $2}'`
    MMONTHFULLNAME=`namaBulanM ${MMONTHNUMBER}`
    HMONTHNUMBER=`echo "${HDATE}" | awk -F- '{print $2}'`
    HMONTHFULLNAME=`namaBulanH ${HMONTHNUMBER}`

    local nomborHari=`nomHari $DAY`
    #local nomborNextHari=$(( $nomborHari + 1 ))
    local nomborNextHari=`nomNextHari $nomborHari`
    local hariInBM=`namaHariBM $nomborHari`
    local nextHariInBM=`namaHariBM $nomborNextHari`
    log DEBUG "nomborNexHari=${nomborNextHari}"
    log DEBUG "nextHariInBM=${nextHariInBM}"

    #out+="Downloaded from www.e-solat.gov.my on"
    #out+="Downloaded on"                                                        # Need shorten the overall text line, because Thinkpad X220 sceen not wide enough to display it
    out+=""                                                        # Need shorten the overall text line, because Thinkpad X220 sceen not wide enough to display it
    out+="<fc=#${cGrey}>Data"                                                        # Need shorten the overall text line, because Thinkpad X220 sceen not wide enough to display it
    out+=" ${mDate}"                                        # Masihi date
    out+=" ${mTime};</fc>"                                       # Time
    #------------------
    out+=" "
    if $ERROR; then
        out+="<fc=#ffffff,#ff4d4d>OLD</fc>"                                   # Mark old data
    else
        out+="   "
    fi
    out+=" "
    #------------------
    out+=""
    out+="<fc=#${cPink}>(${zone}</fc>"                                           # Area/Zone
    out+=" <fc=#${cBlue}>(${MMONTHFULLNAME:0:3}</fc>"                         # Masihi month
    out+=" <fc=#${cBlue}>${mDate}</fc>"                                         # Masihi date
    out+=" <fc=#${cBlue}>${DAY:0:3}</fc>"                                     # Day in English

    out+=" "
    out+="<fc=#${cYellow}>(${HMONTHFULLNAME}</fc>"
    out+=" <fc=#${cYellow}>${HDATE}</fc>"                                         # Hijrah date
    out+=" <fc=#${cYellow}>${hariInBM:0:3}</fc>"
    out+=" "

    #for i in "${!NAMASOLAT[@]}"; do
    #    #out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff> ${MASASOLAT[$i]} </fc> "
    #    out+="<fc=#00ff00>${NAMASOLAT[$i]}</fc><fc=#ffffff>${MASASOLAT[$i]}</fc> "
    #done
    i=0
    #out+="<fc=#000000,#ffffff>${NAMASOLAT[$i]:0:3}</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc> " # Imsak
    out+="<fc=#000000,#ffffff>Ims</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc> " # Imsak
    i=1
    #out+="<fc=#000000,#ffffff>${NAMASOLAT[$i]:0:3}</fc><fc=#000000,#00ff00>${MASASOLAT[$i]}</fc> " # Fajr (Subuh)
    out+="<fc=#000000,#ffffff>Fjr</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc> " # Fajr (Subuh)
    i=2
    #out+="<fc=#000000,#ffffff>${NAMASOLAT[$i]:0:3}</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc> " # Syuruk
    out+="<fc=#000000,#ffffff>Syu</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc> " # Syuruk
    i=3
    #out+="<fc=#000000,#ffffff>${NAMASOLAT[$i]:0:3}</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc> " # Zohr
    out+="<fc=#000000,#ffffff>Zhr</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc> " # Zohr
    i=4
    #out+="<fc=#000000,#ffffff>${NAMASOLAT[$i]:0:3}</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc>" # Asr
    out+="<fc=#000000,#ffffff>Asr</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc>" # Asr
    out+="<fc=#${cYellow}>)</fc> "
    out+="<fc=#${cYellow}>(${nextHariInBM:0:3}</fc> "
    i=5
    #out+="<fc=#000000,#ffffff>${NAMASOLAT[$i]:0:3}</fc><fc=#000000,#00ff00>${MASASOLAT[$i]} </fc> " # Maghrib
    out+="<fc=#000000,#ffffff>Mgh</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc> " # Maghrib
    i=6
    #out+="<fc=#000000,#ffffff>${NAMASOLAT[$i]:0:3}</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc>" # Isyak
    out+="<fc=#000000,#ffffff>Isy</fc><fc=#000000,#00ff00> ${MASASOLAT[$i]} </fc>" # Isyak
    out+="<fc=#${cYellow}>)</fc><fc=#${cBlue}>)</fc><fc=#${cPink}>)</fc>"

    #echo -en "${out}\n"
    ONELINE="${out}"

    log DEBUG "End formatWaktuSolatForXmobar()"
    }


formatWaktuSolatForXmobar2() {
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

    local nomborHari=`nomHari $DAY`
    local hariInBM=`namaHariBM $nomborHari`

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

    out+=" "
    out+="$hariInBM"

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
