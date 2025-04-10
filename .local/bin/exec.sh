#!/bin/bash
# wrapper.sh - A universal launcher for managing background processes.
# Author: 4ndr0666
#
# Usage:
#    ./wrapper.sh [--restart|-r] <APP_PATH> [arguments...]
#
# This script ensures that the application is not already running and,
# if not, launches it in the background and records its PID in a file.
# It uses the classic "backgrounding with echoing the PID" method.

# --- Validate input ---
if [ -z "$1" ]; then
	echo "Usage: $0 [--restart|-r] <APP_PATH> [arguments...]" >&2
	exit 1
fi

# --- Optional force restart flag ---
FORCE_RESTART=false
if [ "$1" = "--restart" ] || [ "$1" = "-r" ]; then
	FORCE_RESTART=true
	shift
fi

# --- Configuration ---
APP_PATH="$1" # Full path to your application binary
shift         # Remove APP_PATH from the argument list
APP_NAME="$(basename "$APP_PATH")"
PIDDIR="/tmp"
PIDFILE="${PIDDIR}/${APP_NAME}.pid"

# --- Validate APP_PATH and executability ---
if [ ! -x "$APP_PATH" ]; then
	echo "Error: $APP_PATH is not executable or not found." >&2
	exit 1
fi

# --- Function to check if process is running ---
is_running() {
	if [ -f "$PIDFILE" ]; then
		PID=$(cat "$PIDFILE")
		if kill -0 "$PID" 2>/dev/null; then
			return 0 # running
		else
			echo "Stale PID file $PIDFILE found. Removing..." >&2
			rm -f "$PIDFILE"
		fi
	fi
	return 1 # not running
}

# --- Main Execution ---
if is_running; then
	if $FORCE_RESTART; then
		echo "Force restarting $APP_NAME..."
		kill "$(cat "$PIDFILE")" 2>/dev/null
		rm -f "$PIDFILE"
		sleep 1
	else
		echo "$APP_NAME is already running (PID $(cat "$PIDFILE"))." >&2
		exit 0
	fi
fi

# Optionally log output if VERBOSE is set to true.
if [ "$VERBOSE" = "true" ]; then
	LOGFILE="/tmp/${APP_NAME}.log"
	nohup "$APP_PATH" "$@" >"$LOGFILE" 2>&1 &
else
	nohup "$APP_PATH" "$@" >/dev/null 2>&1 &
fi

PID=$!
echo $PID >"$PIDFILE"
echo "$APP_NAME started with PID $PID."

# Uncomment the following trap if you wish to remove the PID file when the wrapper exits.
# (Not recommended if you want the PID file to persist for later control.)
# trap "rm -f $PIDFILE" EXIT

exit 0
