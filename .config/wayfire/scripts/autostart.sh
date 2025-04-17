#!/usr/bin/env bash
# File: ~/.config/wayfire/scripts/autostart.sh
# Author: 4ndr0666
# Desc : Unified autostart script to launch tasks with minimal overhead.

SCRIPTS_DIR="$HOME/.config/wayfire/scripts"

# 1) Apply your GTK themes. (Previously: gtkthemes)
#    Optional: background it if you prefer, or just run it inline:
"$SCRIPTS_DIR/gtkthemes" &

# 2) Set the wallpaper in the background (previously: wallpaper)
"$SCRIPTS_DIR/wallpaper" &
echo $! > /tmp/wallpaper.pid

# 3) Launch the status bar if not already running (previously: statusbar)
if ! pidof waybar > /dev/null; then
    "$SCRIPTS_DIR/statusbar" &
    echo $! > /tmp/waybar.pid
fi

# 4) Start notifications (mako) if not already running (previously: notifications)
if ! pidof mako > /dev/null; then
    "$SCRIPTS_DIR/notifications" &
    echo $! > /tmp/mako.pid
fi

# 5) Additional tasks as needed:
# You can launch any other scripts here – for example, if you want to run your theme script at login:
# "$HOME/.config/wayfire/theme/theme.sh" --pywal &

# 6) Done.
exit 0
