#!/bin/sh

USAGE="
    Usage:
    $(basename $0) <event-file> <command> [<arg> ...]
"

. "$(dirname $(readlink -f $0))/utils"

[ -z "$2" ] && err "$USAGE"

EVENT_FILE="$1"
shift

COMMAND_FILE="$(which "$1")"
[ -z "$COMMAND_FILE" ] && err "Command '$1' is not found or is not executable"
shift

trap 'TERMINATED=1' SIGINT SIGTERM SIGHUP SIGQUIT

while [ -z "$TERMINATED" ]
do
    if [ -f "$EVENT_FILE" ]
    then
        EVENT_DATA="$(cat $EVENT_FILE)"
        rm "$EVENT_FILE"

        echo '--' $(date) "$COMMAND_FILE" "$@"

        echo "$EVENT_DATA" | "$COMMAND_FILE" "$@" || err 'failure'
    else
        sleep 3
    fi
done
