#!/bin/bash

source /usr/local/bin/colours.sh
source /usr/local/bin/log.sh

printf "\n${WHITE}${uWHITE}Logger, log() - Demo:${RESET}\n"

log "info" "This is INFO"
log "warn" "This is a WARNING"
log "error" "There was an ERROR"
log "msg" "This is just a MSG"
log "my_custom_level" "This is a custom LOG_LEVEL label"

printf "\n\n"
