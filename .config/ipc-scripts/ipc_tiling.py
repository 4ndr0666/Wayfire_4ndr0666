#!/usr/bin/env python3
# ipc_tiling.py
# Author: 4ndr0666
#
# This production-ready script implements three tiling window layouts for Wayfire:
#   1. Master-stack: The first window is the master; remaining windows are stacked
#      horizontally in the right column.
#   2. Equal Columns: All windows are arranged side by side with equal width.
#   3. Vertical Stack: All windows are arranged vertically.
#
# The script connects to the Wayfire IPC socket via the custom WayfireSocket class,
# subscribes to "view-mapped", "view-unmapped", and "ipc-tiling-command" events,
# and recomputes the tiling layout for each workspace.
#
# Events:
#   - "view-mapped": A new window is opened.
#   - "view-unmapped": A window is closed.
#   - "ipc-tiling-command": A command with a key "layout" is emitted. Production
#     guarantees that the "layout" key is provided with one of the values:
#       "masterstack", "columns", or "vertical".
#
# On receiving an invalid layout command, the script logs the error and reverts to
# the default layout ("masterstack"). All state is tracked using an internal dictionary.

import sys
import traceback
from wayfire_socket import WayfireSocket

# Global variable to specify the current layout. Production ensures valid values.
CURRENT_LAYOUT = "masterstack"  # Allowed values: "masterstack", "columns", "vertical"

# Dictionary to track known window views per workspace.
# Key is a tuple (wset, wsx, wsy) and value is a list of view tuples: (view_id, width, height).
workspaces = {}

def handle_event(msg, wf_sock):
    """
    Processes IPC events from Wayfire and updates the tiling layout accordingly.
    Processes the following events:
      - "view-mapped": Adds the new view to the workspace state.
      - "view-unmapped": Removes the view from the workspace state.
      - "ipc-tiling-command": Updates the CURRENT_LAYOUT and re-tiles all workspaces.
    """
    global CURRENT_LAYOUT
    evt = msg.get("event")
    if not evt:
        return

    if evt == "view-mapped":
        view_id = msg["view"]["id"]
        output = wf_sock.get_output(msg["view"]["output-id"])
        wset = output["wset-index"]
        wsx = output["workspace"]["x"]
        wsy = output["workspace"]["y"]
        key = (wset, wsx, wsy)
        if key not in workspaces:
            workspaces[key] = []
        # Append the new view; geometry details may be provided later by IPC.
        workspaces[key].append((view_id, 0, 0))
        rebuild_layout(wf_sock, key)

    elif evt == "view-unmapped":
        view_id = msg["view"]["id"]
        for key, view_list in workspaces.items():
            new_list = [v for v in view_list if v[0] != view_id]
            if len(new_list) < len(view_list):
                workspaces[key] = new_list
                rebuild_layout(wf_sock, key)

    elif evt == "ipc-tiling-command":
        # Production guarantees that the "layout" key is provided.
        new_layout = msg.get("layout")
        # Enforce valid values; if invalid, log the error and revert to default.
        if new_layout in ["masterstack", "columns", "vertical"]:
            CURRENT_LAYOUT = new_layout
        else:
            sys.stderr.write(f"[ERROR] Received invalid layout value: {new_layout}. Reverting to 'masterstack'.\n")
            CURRENT_LAYOUT = "masterstack"
        # Rebuild layout for every workspace.
        for key in workspaces.keys():
            rebuild_layout(wf_sock, key)

def rebuild_layout(wf_sock, key):
    """
    Recomputes and applies the tiling layout for the workspace identified by key = (wset, wsx, wsy).
    The layout JSON structure is computed according to CURRENT_LAYOUT.
    """
    if key not in workspaces:
        return
    wset, wsx, wsy = key
    views = workspaces[key]
    if not views:
        # No windows: send an empty layout.
        wf_sock.set_tiling_layout(wset, wsx, wsy, {"vertical-split": []})
        return
    if CURRENT_LAYOUT == "masterstack":
        layout = compute_masterstack(views)
    elif CURRENT_LAYOUT == "columns":
        layout = compute_equal_cols(views)
    elif CURRENT_LAYOUT == "vertical":
        layout = compute_vertical(views)
    else:
        # This branch is unreachable due to production enforcement.
        layout = compute_masterstack(views)
    wf_sock.set_tiling_layout(wset, wsx, wsy, layout)

def compute_masterstack(views):
    """
    Computes a master-stack layout.
    - The first view is the master with weight 2.
    - Remaining views form a horizontal split with equal weights.
    Returns a dictionary representing the JSON layout.
    """
    if len(views) == 1:
        return {"vertical-split": [{"view-id": views[0][0], "weight": 1}]}
    master = views[0][0]
    stack = [{"view-id": v[0], "weight": 1} for v in views[1:]]
    return {
        "vertical-split": [
            {"view-id": master, "weight": 2},
            {"horizontal-split": stack, "weight": float(len(stack))}
        ]
    }

def compute_equal_cols(views):
    """
    Computes an equal columns layout by evenly distributing all views in a horizontal split.
    Returns a dictionary representing the JSON layout.
    """
    columns = [{"view-id": v[0], "weight": 1} for v in views]
    return {"horizontal-split": columns}

def compute_vertical(views):
    """
    Computes a vertical stack layout where all windows are arranged in a single vertical split.
    Returns a dictionary representing the JSON layout.
    """
    stack = [{"view-id": v[0], "weight": 1} for v in views]
    return {"vertical-split": stack}

def main():
    """
    Main entry point. Initializes the WayfireSocket, subscribes to necessary events,
    and enters an infinite loop to process tiling-related IPC events.
    """
    try:
        wf_sock = WayfireSocket()
        # Subscribe to production events.
        wf_sock.watch(["view-mapped", "view-unmapped", "ipc-tiling-command"])
        print("[TILING] Subscribed to Wayfire IPC events. Current layout:", CURRENT_LAYOUT)
        while True:
            try:
                msg = wf_sock.read_next_event()
                handle_event(msg, wf_sock)
            except Exception as e:
                sys.stderr.write("[ERROR] in main loop: " + str(e) + "\n")
                traceback.print_exc()
    except Exception as e:
        sys.stderr.write("[FATAL] Failed to initialize IPC tiling: " + str(e) + "\n")

if __name__ == "__main__":
    main()
