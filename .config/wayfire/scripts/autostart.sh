#!/usr/bin/env bash
# Author: 4ndr0666
# ========================= // AUTOSTART.SH //
## Description : Launches with the autostart 
#               module in wayfire.ini
# ----------------------------------------

## Global Constants
SCRIPTS_DIR="$HOME/.config/wayfire/scripts"

## Scripts

### gtkthemes
"$SCRIPTS_DIR/gtkthemes" &

### wallpaper
"$SCRIPTS_DIR/wallpaper" &
echo $! > /tmp/wallpaper.pid

### waybar
if ! pidof waybar > /dev/null; then
    "$SCRIPTS_DIR/statusbar" &
    echo $! > /tmp/waybar.pid
fi

### mako
if ! pidof mako > /dev/null; then
    "$SCRIPTS_DIR/notifications" &
    echo $! > /tmp/mako.pid
fi

### theme
"$HOME/.config/wayfire/theme/theme.sh" --default &

exit 0
