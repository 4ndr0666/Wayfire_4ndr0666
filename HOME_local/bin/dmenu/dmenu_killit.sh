#!/bin/sh

# Function to display dmenu prompt
dmenu_prompt() {
  echo -e "$1" | dmenu -i -l 10
}

# Function to kill selected process
kill_process() {
  local pids="$1"
  local pid=$(echo "$pids" | dmenu_prompt "Found processes:\n$pids\nPlease enter the PID to kill:")

  if [ -z "$pid" ]; then
    echo "No PID provided, no action taken."
    return 1
  fi

  if ! echo "$pids" | grep -q "$pid"; then
    echo "PID $pid does not match any of the listed processes."
    return 1
  fi

  sudo kill -9 "$pid" && echo "Process $pid killed." || echo "Failed to kill process $pid."
}

# Main loop
while true; do
    # Prompt for a process name to search for
    search_pattern=$(echo "" | dmenu -p "Enter a process name to search for:")

    # Search for processes matching the provided pattern
    matching_processes=$(pgrep -fla "$search_pattern")

    # Check if any processes are found
    if [ -z "$matching_processes" ]; then
        exit_option="Exit"
        echo "No processes found matching '$search_pattern'."
    else
        exit_option="Try another search"
    fi

    # Kill the selected process or exit
    kill_process "$matching_processes"

    # Prompt to exit or try another search
    choice=$(echo -e "$exit_option" | dmenu_prompt "Select an option: (Ctrl+\\ to exit)")

    if [ "$choice" == "Exit" ]; then
        exit 0
    fi
done
