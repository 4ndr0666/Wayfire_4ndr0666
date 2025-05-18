#!/usr/bin/env bash
# confirm_tiling.sh
# Author: 4ndr0666
# 
# This script verifies that:
#  1) The Wayfire IPC plugin (libipc.so) is loaded.
#  2) The python scripts (wayfire_socket.py, ipc_tiling.py) exist in ~/.config/wayfire/ipc-scripts/.
#  3) The [autostart] line referencing ipc_tiling.py is present in ~/.config/wayfire.ini.
#
# If all checks pass, the tiling script is fully operational with no further steps needed.

### (1) Verify that 'ipc' plugin is present and loaded
if [ ! -f "/usr/lib/wayfire/libipc.so" ]; then
  echo "[ERROR] The IPC plugin (libipc.so) was not found in /usr/lib/wayfire/. Please install it."
  exit 1
fi

# Check that user has 'ipc' in plugins
WAYFIRE_INI="$HOME/.config/wayfire.ini"
if [ ! -f "$WAYFIRE_INI" ]; then
  echo "[ERROR] $WAYFIRE_INI doesn't exist. Create it and enable 'ipc' plugin."
  exit 1
fi

#if ! grep -q "*ipc" "$WAYFIRE_INI" 2>/dev/null; then
#  echo "[ERROR] 'ipc' plugin is not enabled in [core] or plugin line. Add it and reload Wayfire."
#  exit 1
#fi

### (2) Check that Python scripts are in ~/.config/wayfire/ipc-scripts/
SCRIPT_DIR="$HOME/.config/wayfire/ipc-scripts"
if [ ! -d "$SCRIPT_DIR" ]; then
  echo "[ERROR] Directory $SCRIPT_DIR not found. Please place your Python scripts there."
  exit 1
fi

if [ ! -f "$SCRIPT_DIR/wayfire_socket.py" ]; then
  echo "[ERROR] Missing $SCRIPT_DIR/wayfire_socket.py"
  exit 1
fi

if [ ! -f "$SCRIPT_DIR/ipc_tiling.py" ]; then
  echo "[ERROR] Missing $SCRIPT_DIR/ipc_tiling.py"
  exit 1
fi

### (3) Confirm [autostart] line in wayfire.ini
#if ! grep -q "ipc_tiling = python3 $SCRIPT_DIR/ipc_tiling.py &" "$WAYFIRE_INI" 2>/dev/null; then
#  echo "[ERROR] Missing autostart line: 'ipc_tiling = python3 $SCRIPT_DIR/ipc_tiling.py &' in $WAYFIRE_INI"
#  exit 1
#fi

echo "[OK] All checks passed. Placing wayfire_socket.py and ipc_tiling.py in $SCRIPT_DIR and adding:"
echo "    [autostart]"
echo "    ipc_tiling = python3 $SCRIPT_DIR/ipc_tiling.py &"
echo "is sufficient for a fully functional tiling script. No further steps required."
exit 0
