#!/bin/bash
source /usr/local/bin/colours.sh

if [ -n "$LOGGER_LOADED" ]; then
    return
fi
declare -g LOGGER_LOADED=1

##
# Logging function w/ timestamp, and 4 levels w/ hi-int ANSI colours
#   - info                      (green)
#   - warn                      (yellow)
#   - error                     (red)
#   - msg, or a custom label    (grey)
#
# Usage:
# Update source path to `colours.sh`, if needed.
#
# `log LOG_LEVEL MESSAGE`
#
#   - LOG_LEVEL
#     - string: error, warn, info, msg (default)
#       - custom labels allowed, styled similar to msg level
#     - case insensitive
#   - MESSAGE (string)
#
# Examples:
# `log "warn" "They're on to you..."`
# `log "error" "The system is down."`
# `log "GOT HERE" "This is a custom message level (`msg`) log"
#
# See: https://github.com/farhanjiwani/shell-scripts/blob/main/colours.sh
##

log() {
    local LEVEL=$1
    local MSG=$2
    local MSG_COL=$RESET
    local TIME=$(date +"%H:%M:%S")

    # Default LEVEL
    if [ $1 == "" ]; then
        LEVEL="MSG"
    fi
    
    case "/${LEVEL^^}/" in  # make it uppercase
        "/INFO/")     COL=$hGREEN ;;
        "/WARN/")     COL=$hYELLOW ;;
        "/ERROR/")    COL=$hRED ;;
        "/MSG/")      COL=$hBLACK && MSG_COL=$hBLACK ;;
        *)            COL=$hBLACK ;;
    esac

    printf "${hBLACK}[${TIME}]${RESET} ${COL}[${LEVEL^^}] "
    printf "${MSG_COL}${MSG}${RESET}\n"
}
