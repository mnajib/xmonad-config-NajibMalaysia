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
#LOG_FILE="/tmp/${USER}-xmonad.log"
#
# XXX: need to check for LOG_FILE

# Set the log level
set_log_level() {
    local level="$1"
    case "$level" in
        silent) LOG_LEVEL=$LOG_LEVEL_SILENT ;;
        error)  LOG_LEVEL=$LOG_LEVEL_ERROR ;;
        warn)   LOG_LEVEL=$LOG_LEVEL_WARN ;;
        info)   LOG_LEVEL=$LOG_LEVEL_INFO ;;
        debug)  LOG_LEVEL=$LOG_LEVEL_DEBUG ;;
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

# Generic log function
log() {
    local level="$1"
    local message="$2"
    local level_value=0

    case "$level" in
        error) level_value=$LOG_LEVEL_ERROR ;;
        warn)  level_value=$LOG_LEVEL_WARN ;;
        info)  level_value=$LOG_LEVEL_INFO ;;
        debug) level_value=$LOG_LEVEL_DEBUG ;;
    esac

    if (( LOG_LEVEL >= level_value )); then
        echo "[$level] $message" >&2
        echo "[$level] $message" >> "$LOG_FILE"
    else
        echo "[$level] $message" >> "$LOG_FILE"
    fi
}

# Convenience functions
log_error() { log "error" "$1"; }
log_warn() { log "warn" "$1"; }
log_info() { log "info" "$1"; }
log_debug() { log "debug" "$1"; }

#log_debug "Sourced logger.sh"
