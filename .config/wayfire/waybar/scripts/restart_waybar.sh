#!/usr/bin/env bash

restart_waybar() {
    notify-send "🔄 Restarting Waybar..."
    pkill -TERM waybar
    sleep 1
    # Check if Waybar is still running, force kill if necessary
    if pgrep waybar &>/dev/null; then
        pkill -9 waybar
    fi
}

start_waybar() {
    # Restart Waybar without attaching to the current terminal
    waybar </dev/null &>/dev/null &
    notify-send "✅ Waybar has been restarted."
}

restart_waybar
start_waybar
