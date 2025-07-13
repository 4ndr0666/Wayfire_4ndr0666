#!/usr/bin/env bash
# Author: 4ndr0666
# ========================= // AUTOSTART.SH //
## Description : Launches with the autostart
#               module in wayfire.ini
# ----------------------------------------

# Global Constants
DIR="/home/andro/.config/wayfire/scripts"

# Gtkthemes
bash "$DIR/gtkthemes" &

# Wallpaper
bash "$DIR/wallpaper" &

## Waybar
if ! pidof waybar > /dev/null; then
    bash "$DIR/statusbar" &
    echo $! > /tmp/waybar.pid
fi

# Mako
if ! pidof mako > /dev/null; then
    bash "$DIR/notifications" &
    echo $! > /tmp/mako.pid
fi

# Theme
bash /home/andro/.config/wayfire/theme/theme.sh --default &

# Mem-police
sudo -bs --user=root /usr/bin/mem-police 

exit 0
