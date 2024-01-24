#!/usr/bin/env bash

LOG_FILE="/tmp/${USER}-loglib.log"
LOG_LEVEL="silent"

logToFile(){
  echo "$1" >> "$LOG_FILE"
}

logToScreen(){
  echo "$1"
}

logWrite(){
  if [ -n "$LOG_FILE" ]; then
    logToFile "$1"
  else
    logToScreen "$1"
  fi
}

log(){
  local message_type="$1"
  local message="$2"

  case $LOG_LEVEL in
    #--------------------------------------------------
    "high"|"HIGH"|"3"|"verbose"|"VERBOSE")  # log all/everything we can get
      case $message_type in
        "error"|"ERROR")
          logWrite "ERROR: $message"
          ;;
        "verbose"|"VERBOSE"|"debug"|"DEBUG")
          #logWrite "VERBOSE: $message"
          logWrite "DEBUG: $message"
          ;;
        "info"|"INFO")
          logWrite "INFO: $message"
          ;;
      esac
      ;;
    #--------------------------------------------------
    "medium"|"MEDIUM"|"2"|"info"|"INFO")     # log error and warning
      case $message_type in
        "error"|"ERROR")
          logWrite "ERROR: $message"
          ;;
        "info"|"INFO"|"normal"|"NORMAL")
          logWrite "INFO: $message"
          ;;
      esac
      ;;
    #--------------------------------------------------
    "low"|"LOW"|"1"|"error"|"ERROR")    # onlo log error
      case $message_type in
        "error"|"ERROR")
          logWrite "ERROR: $message"
          ;;
      esac
      ;;
    #--------------------------------------------------
    "0"|"silent"|"SILENT"|"mute"|"MUTE")   # no log
      # do nothing
      ;;
    #--------------------------------------------------
    *)
      logWrite "XXX: $message"
      ;;
  esac
}

setLogLevel() {
  LOG_LEVEL="$1"
  log "verbose" "setLogLevel: Log level set to: $LOG_LEVEL"
}

#log "VERBOSE" "loglib.sh: <-- end of file"
