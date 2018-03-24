#!/bin/sh

WORKERS_FILE="$1"
DISPATCHER_DIR="$(dirname $(readlink -f $0))"
LISTENER="$DISPATCHER_DIR/.listener.sh"

. "$DISPATCHER_DIR/utils"

[ -z "$WORKERS_FILE" ] && err "Workers definition file is not specified"
WORKERS_FILE="$(readlink -f "$WORKERS_FILE")"
[ -f "$WORKERS_FILE" ] || err "Workers definition file is not found"

trap 'kill $(jobs -p); wait;' SIGINT SIGTERM SIGHUP SIGQUIT

listen_and_do() { "$LISTENER" "$@" & }

cd "$(dirname "$WORKERS_FILE")"

PATH=".:$PATH"

. "$WORKERS_FILE"

wait
