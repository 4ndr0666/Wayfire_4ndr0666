#!/usr/bin/python3

import logging
from wayfire import WayfireSocket
from wayfire.extra.wpe import WPE

# Set up logging to track events and errors
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Create Wayfire socket and WPE instance
socket = WayfireSocket()
wpe = WPE(socket)

# Watch for view-mapped events (when a new window is opened)
socket.watch(['view-mapped'])

def create_dwindle_layout(views):
    """Recursively apply the dwindle layout."""
    if not views:
        return {}
    
    view_id = views[0]["view-id"]
    weight = views[0]["geometry"]["width"]
    
    if len(views) == 1:
        return {'view-id': view_id, 'weight': 1}
    
    # The first view takes most of the space
    first_split = {'view-id': view_id, 'weight': 0.67}
    # The rest of the views are dwindled
    dwindle_split = create_dwindle_layout(views[1:])
    
    return {'horizontal-split': [first_split, dwindle_split]}

def tile_new_view(view):
    """Apply the dwindle tiling logic when a new view is mapped."""
    try:
        # Get the output and workspace information
        output = socket.get_output(view["output-id"])
        wset = output['wset-index']
        wsx = output['workspace']['x']
        wsy = output['workspace']['y']
        layout = socket.get_tiling_layout(wset, wsx, wsy)
        all_views = create_list_views(layout)

        if not all_views or (len(all_views) == 1 and all_views[0][0] == view["id"]):
            # Case: Only one view, place it in full layout
            desired_layout = {'view-id': view["id"], 'weight': 1}
            socket.set_tiling_layout(wset, wsx, wsy, desired_layout)
            logging.info(f"Single view {view['id']} set in full layout.")
            return

        # Dwindle the layout
        all_views.append(view)
        desired_layout = create_dwindle_layout(all_views)
        socket.set_tiling_layout(wset, wsx, wsy, desired_layout)
        logging.info(f"View {view['id']} added to dwindle layout.")

    except Exception as e:
        logging.error(f"Failed to tile view {view['id']}: {e}")

# Main event loop to handle view-mapped events
while True:
    try:
        msg = socket.read_next_event()
        if "event" in msg:
            view = msg["view"]
            if view["type"] == "toplevel" and view["parent"] == -1:
                tile_new_view(view)
    except Exception as e:
        logging.error(f"Error reading event: {e}")
