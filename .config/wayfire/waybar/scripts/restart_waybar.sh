#!/bin/bash
# Toggle Waybar visibility using swaymsg IPC with a fallback to a restart if needed.
# Targets the bar with id "main-bar".

BAR_ID="main-bar"

# Function to restart Waybar completely
restart_waybar() {
    notify-send "Waybar Toggle" "Restarting Waybar..."
    pkill -TERM waybar
    sleep 1
    if pgrep -x "waybar" >/dev/null; then
        pkill -9 waybar
    fi
    # Restart Waybar without tying to the current terminal
    waybar >/dev/null 2>&1 &
    notify-send "Waybar Toggle" "Waybar restarted."
}

# Ensure Waybar is running
if ! pgrep -x "waybar" >/dev/null; then
    notify-send "Waybar Toggle" "Waybar is not running, starting Waybar."
    waybar >/dev/null 2>&1 &
    exit 0
fi

# Attempt to query the current visibility state using swaymsg and jq
current_state=$(swaymsg -t get_bar -p | jq -r --arg id "$BAR_ID" 'map(select(.id==$id))[0].visible' 2>/dev/null)

if [ "$current_state" == "true" ]; then
    swaymsg bar "$BAR_ID" disable
    notify-send "Waybar Toggle" "Waybar hidden."
elif [ "$current_state" == "false" ]; then
    swaymsg bar "$BAR_ID" enable
    notify-send "Waybar Toggle" "Waybar shown."
else
    notify-send "Waybar Toggle" "State undetermined; restarting Waybar."
    restart_waybar
fi
