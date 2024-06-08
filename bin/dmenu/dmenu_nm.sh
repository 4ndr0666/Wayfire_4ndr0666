#!/bin/sh

OPTION=$(echo -e "Connect\nDisconnect\nStatus" | dmenu -p "Network Manager:")

case "$OPTION" in
    Connect)
        SSID=$(nmcli d wifi list | tail -n +2 | awk '{print $2}' | dmenu -p "Select Network:")
        [ -n "$SSID" ] && nmcli d wifi connect "$SSID" || notify-send "Connection cancelled."
        ;;
    Disconnect)
        DEVICE=$(nmcli device status | grep wifi | awk '{print $1}' | dmenu -p "Select Device:")
        [ -n "$DEVICE" ] && nmcli d disconnect "$DEVICE" || notify-send "Disconnection cancelled."
        ;;
    Status)
        STATUS=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)
        [ -n "$STATUS" ] && notify-send "Connected to $STATUS" || notify-send "Not connected to any network."
        ;;
    *)
        notify-send "Action cancelled."
        ;;
esac
