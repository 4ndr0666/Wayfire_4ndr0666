#!/bin/sh

yad --width=330 --height=550 \
--center \
--fixed \
--title="Keybindings" \
--no-buttons \
--list \
--column=Key: \
--column=Description: \
--column= \
--timeout=30 \
--timeout-indicator=right \
"+D" "Main Menu" "" \
"+N" "Network Manager" "" \
"+X" "Power Menu" "" \
"+L" "Lock Screen" "" \
"+P" "Color Picker" "" \
"Alt+F1" "Wofi Clipboard" "" \
"+V" "Scale All Windows" "" \
"+0" "OOM Killer" "" \
"+C" "Aura Theme" "" \
"+Shift+C" "Random Theme" "" \
"+R" "Application Runner" "" \
"+Shift+R" "Run Command as Root" "" \
"+S" "Screenshot Tool" "" \
"Print" "Select Screenshot Area" "" \
"Shift+Print" "Screenshot in 5sec" "" \
"+Print" "Screenshot in 10sec" "" \
"+W" "Brave" "" \
"+F" "Thunar" "" \
"+E" "Geany" "" \
"+B" "Restart Waybar" "" \
"+F1" "Play All MPVs" "" \
"+Shift+F1" "Pause All MPVs" "" \
"+F2" "LF" "" \
"+F3" "Micro" "" \
"+Shift+F3" "Neovim" "" \
"+F4" "Diffuse" "" \
"+Shift+F4" "Meld" "" \
"+F5" "Vidcut" "" \
"+Shift+F5" "LosslessCut" "" \
"+F6" "Searchmaster" "" \
"+F7" "JDownloader" "" \
"+F8" "4ndr0update" "" \
"+Shift+F8" "PacUI" "" \
"+F9" "Dmenuhandler" "" \
"+Shift+F9" "Wofi Media" "" \
"+F10" "" "" \
"+F11" "" "" \
"+F12" "Dmenu Record" "" \
"+Spacebar" "Toggle floating mode" "" \
"Ctrl+Shift+F9" "Minimize" "" \
"Ctrl+Shift+F10" "Always On Top" "" \
"Ctrl+Shift+F11" "Sticky" "" \
"+Shift+rightclick" "3d-Wrot" "" \
"=Ctrl+rightclick" "Wrot" "" 
