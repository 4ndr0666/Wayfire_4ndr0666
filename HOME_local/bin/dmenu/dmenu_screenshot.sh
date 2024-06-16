
#!/bin/bash

# Screenshot directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# Ensure the screenshot directory exists
mkdir -p "$SCREENSHOT_DIR"

# Function to display dmenu prompt
dmenu_prompt() {
  echo -e "$1" | dmenu -i -l 10
}

# Function to take a screenshot
take_screenshot() {
  local option="$1"
  local filename="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"

  case "$option" in
    "Full Screen")
      maim "$filename"
      ;;
    "Active Window")
      maim -i $(xdotool getactivewindow) "$filename"
      ;;
    "Select Area")
      maim -s "$filename"
      ;;
    "Screenshot in 5 seconds")
      sleep 5
      maim "$filename"
      ;;
    "Screenshot in 10 seconds")
      sleep 10
      maim "$filename"
      ;;
  esac

  # Notify user
  notify-send "Screenshot saved to $filename"
}

# Main menu
while true; do
  choice=$(dmenu_prompt "Full Screen\nActive Window\nSelect Area\nScreenshot in 5 seconds\nScreenshot in 10 seconds\nExit")
  case "$choice" in
    "Full Screen"|"Active Window"|"Select Area"|"Screenshot in 5 seconds"|"Screenshot in 10 seconds")
      take_screenshot "$choice"
      ;;
    "Exit")
      exit 0
      ;;
  esac
done
