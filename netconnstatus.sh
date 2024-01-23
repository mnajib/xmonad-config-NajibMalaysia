#!/usr/bin/env bash

#------------------------------------------------------------------------------

PING=~/.xmonad/bin/NetConnStatus.sh
#DATE=~/.xmonad/bin/date.sh
#LOGLIB=~/.xmonad/loglib.sh

# XXX: TODO: ERROR????
#source loglib.sh
#source "$LOGLIB"

#LOGFILE=~/.xmonad/var/${USER}-NetConnStatus.log # date_time, LAN_status, WAN_status
#LOGFILE="/tmp/${USER}-NetConnStatus.log" # date_time, LAN_status, WAN_status
LOG_FILE=/tmp/${USER}-NetConnStatus.log # date_time, LAN_status, WAN_status
LOG_LEVEL="silent"    # silent (no log), error (only log error), ...
#LOG_LEVEL="verbose"    # silent (no log), error (only log error), ...

INTERFACE=enp7s0  # XXX: Not really in use

# IP to run ping test
#LOIP='127.0.0.1'
#LANIP='1.1.1.1'    # XXX: Not really in use
WANIP='1.1.1.1'

# Network status (0 up; 1 down)
#OSTATUS=1
LSTATUS=1
WSTATUS=1

# UP
FgColor1="#181715"
BgColor1="#58C5F1"
# DOWN
FgColor2="#646464"
BgColor2="#ff0000"

timeInterval=3 #2 #5 #10 #15 60

#------------------------------------------------------------------------------
#:'

currentDT(){
  #echo `date +%Y-%m-%d_T%H%M%S`
  echo `date '+%Y-%m-%d %H:%M:%S'`
}

logToFile(){
  #local logMsg="$1"
  #local logFile="$2"
  local dt=`currentDT`
  #echo "$logMsg" >> "$logFile"
  #echo "$logMsg" >> "$LOG_FILE"
  echo "$dt NetConnStatus $1" >> "$LOG_FILE"
}

logToScreen(){
  #local logMsg="$1"
  #echo "$logMsg"
  #echo "$1"
  echo "$dt NetConnStatus $1"
}

log(){
  #local logMsg="$1"
  # if (global) $LOG_FILE is set
  #   log2file
  # else
  #   log2screen
  #if
  #if [ -f "$LOG_FILE" ]; then
  if [ -n "$LOG_FILE" ]; then
    #echo "ERROR: $message"
    #log2file "ERROR: $message"
    #log2file "$logMsg"
    logToFile "$1"
  else
    #echo "ERROR: $message"
    #log2screen "ERROR: $message"
    #log2screen "$logMsg"
    #logToScreen "$1"
    logToFile "$1"
  fi
}

logMessage(){
  local message_type="$1"
  local message="$2"

  case $LOG_LEVEL in
    "verbose")  # log all/everything we can get
      if [ "$message_type" = "error" ]; then
        log "ERROR: $message"
      elif [ "$message_type" = "verbose" ]; then
        log "VERBOSE: $message"
      elif [ "$message_type" = "info" ]; then
        log "INFO: $message"
      fi
      ;;
    "info")     # log error and warning
      if [ "$message_type" = "error" ]; then
        log "ERROR: $message"
      elif [ "$message_type" = "info" ]; then
        log "INFO: $message"
      elif [ "$message_type" = "NORMAL" ]; then
        log "INFO: $message"
      fi
      ;;
    "error")    # onlo log error
      if [ "$message_type" = "error" ]; then
        log "ERROR: $message"
      fi
      ;;
    "silent")   # no log
      # do nothing
      ;;
    *)
      log "XXX: $message"
      ;;
  esac
}

setLogLevel() {
  LOG_LEVEL="$1"
  logMessage "verbose" "setLogLevel: Log level set to '${LOG_LEVEL}'"
}

#'
#------------------------------------------------------------------------------

function f_gwip {
  local gwip
  gwip=$(ip route ls | grep "^default" | sed 's/^default via //g' | sed 's/ dev.*$//g')
  echo "$gwip"
}

function f_ping {
  local ping=$1
  local interface=$2
  local ip=$3

  "${ping}" "${interface}" "${ip}" 2> /dev/null
  local status=$?

  echo $status
}

function f_coloringNetStatus {
  local net=$1
  local status=$2

  #local fgColor=$1
  #local bgColor=$2

  if [ "$status" -eq "0" ]; then
    echo "<fc=${FgColor1},${BgColor1}> ${net}</fc>"
  else
    echo "<fc=${FgColor2},${BgColor2}> ${net}</fc>"
  fi
}

function f_printNetsStatus {
  local #oStatus=$1
  local lStatus=$1 #2
  local wStatus=$2 #3

  #local oColoredStatus=$(f_coloringNetStatus LO $oStatus)
  local lColoredStatus
  local wColoredStatus
  lColoredStatus=$(f_coloringNetStatus LAN "$lStatus")
  wColoredStatus=$(f_coloringNetStatus WAN "$wStatus")

  #echo "${oColoredStatus},${lColoredStatus},${wColoredStatus}"
  echo "${lColoredStatus},${wColoredStatus}"
}

#------------------------------------------------------------------------------

#setLogLevel verbose

while true; do
  # Get network status
  #OSTATUS=$(f_ping ${PING} ${INTERFACE} ${LOIP})
  logMessage "verbose" "LAN IP: $(f_gwip)"
  logMessage "verbose" "WAN IP: ${WANIP}"
  LSTATUS=$(f_ping ${PING} ${INTERFACE} "$(f_gwip)")
  WSTATUS=$(f_ping ${PING} ${INTERFACE} ${WANIP})

  # Print network status
  #f_printNetsStatus $OSTATUS $LSTATUS $WSTATUS
  f_printNetsStatus "$LSTATUS" "$WSTATUS"

  # Sleep before loop
  sleep ${timeInterval}
done
