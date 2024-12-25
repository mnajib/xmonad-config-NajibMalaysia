#!/usr/bin/env bash

# Guard clause to prevent multiple inclusions of this file
[[ "${_LOGGER_SH_INCLUDED:-}" == "true" ]] && return
declare -r _LOGGER_SH_INCLUDED="true"
#log_debug "Sourcing logger.sh"
#echo "Sourcing logger.sh" >> "$LOG_FILE"

# Logging levels
LOG_LEVEL_SILENT=0
LOG_LEVEL_ERROR=1
LOG_LEVEL_WARN=2
LOG_LEVEL_INFO=3
LOG_LEVEL_DEBUG=4

# Default log level
LOG_LEVEL=$LOG_LEVEL_INFO

# Default log file
LOG_FILE="/tmp/${USER}-xmonad.log"
#
# XXX: need to check for LOG_FILE

# Set the log level
set_log_level() {
    local level="$1"
    case "$level" in
        silent|SILENT) LOG_LEVEL=$LOG_LEVEL_SILENT ;;
        error|ERROR)  LOG_LEVEL=$LOG_LEVEL_ERROR ;;
        warn|WARN|warning|WARNING)   LOG_LEVEL=$LOG_LEVEL_WARN ;;
        info|INFO)   LOG_LEVEL=$LOG_LEVEL_INFO ;;
        debug|DEBUG)  LOG_LEVEL=$LOG_LEVEL_DEBUG ;;
        *)      LOG_LEVEL=$LOG_LEVEL_INFO ;;
    esac
}

set_log_file() {
    local file="$1"
    LOG_FILE="$file"
}

get_log_file() {
    echo "$LOG_FILE"
}

# clearing the log file
reset_log_file() {
    local file="$1"
    cat /dev/null > "$file"
}

# Generic log function
log() {
    local message_level="$1"
    local message="$2"
    local message_level_value=0
    local log_file="$3"
    local mode_level_value=$LOG_LEVEL

    case "$message_level" in
        error|ERROR) message_level_value=$LOG_LEVEL_ERROR ;;
        warn|warning|WARN|WARNING)  message_level_value=$LOG_LEVEL_WARN ;;
        info|INFO)  message_level_value=$LOG_LEVEL_INFO ;;
        debug|DEBUG) message_level_value=$LOG_LEVEL_DEBUG ;;
    esac

    # to log file
    # more higher value == more verbose logging
    if (( mode_level_value >= message_level_value )); then
        #echo "[$level] $message" >&2
        #echo "[$level] $message" >> "$LOG_FILE"
        #
        #echo "`date "+%F %T"` ${logmode}: ${logstring}" >> $LOGFILE
        echo "`date "+%F %T"` ${message_level}: ${message}" >> $LOG_FILE
        #echo "`date "+%F %T"` ${level}: ${message}" >> "$log_file"
    #else
    #    echo "[$level] $message" >> /dev/null #"$LOG_FILE"
    fi

    # to screen/display
    #if (( LOG_LEVEL == $LOG_LEVEL_INFO )); then
    #    echo "[$level] $message" >&2
    #fi
}

#
# Usage:
#     log INFO "Length error."
#     log DEBUG "Start fetchData()."
#
#log () {
#    local logmode=$1
#    local logstring=$2
#    #local logfile=$3
#
#    # Will use global var: LOG, LOGMODE
#    if [ "$LOGMODE" = "DEBUG" ]; then
#        # For debugging purpose, log all information
#        echo "`date "+%F %T"` ${logmode}: ${logstring}" >> $LOGFILE
#    elif [ "$LOGMODE" = "NORMAL" ] && [ "$logmode" = "ERROR" ]; then
#        # Normally, just log general information
#        echo "`date "+%F %T"` ${logmode}: ${logstring}" >> $LOGFILE
#    elif [ "$LOGMODE" = "INFO" ] && [ "$logmode" = "INFO" ]; then
#        echo "`date "+%F %T"` ${logmode}: ${logstring}" >> $LOGFILE
#    elif [ "${logmode}" = "ERROR" ]; then
#        echo "`date "+%F %T"` ${logmode}: ${logstring}" >> $LOGFILE
#    fi
#}

# Convenience functions
#log_error() { log "error" "$1" "$LOG_FILE"; }
#log_warn() { log "warn" "$1" "$LOG_FILE"; }
#log_info() { log "info" "$1" "$LOG_FILE"; }
#log_debug() { log "debug" "$1" "$LOG_FILE"; }
log_error() { log "ERROR" "$1" "$LOG_FILE"; }
log_warn() { log "WARN" "$1" "$LOG_FILE"; }
log_info() { log "INFO" "$1" "$LOG_FILE"; }
log_debug() { log "DEBUG" "$1" "$LOG_FILE"; }

#log_debug "Sourced logger.sh"
