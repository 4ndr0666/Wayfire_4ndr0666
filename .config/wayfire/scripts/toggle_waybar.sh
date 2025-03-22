#!/bin/bash
# Author: 4ndr0666

# ===================== // TOGGLE-WAYBAR //

## Global Constants & Variables

CONFIG="$HOME/.config/wayfire/waybar/config"
STYLE="$HOME/.config/wayfire/waybar/style.css"

## Restart Waybar

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
