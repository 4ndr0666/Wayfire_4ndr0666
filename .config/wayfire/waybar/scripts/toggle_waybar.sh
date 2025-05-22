#!/bin/bash
# Author: 4ndr0666

# ===================== // TOGGLE-WAYBAR //

CONFIG="$HOME/.config/wayfire/waybar/config"
STYLE="$HOME/.config/wayfire/waybar/style.css"

restart_waybar() {
    pkill waybar
    sleep 1
    waybar --bar main-bar --config ${CONFIG} --style ${STYLE} &
}

if ! pidof waybar >/dev/null; then
    waybar --bar main-bar --config ${CONFIG} --style ${STYLE} &
    exit 0
fi

restart_waybar
