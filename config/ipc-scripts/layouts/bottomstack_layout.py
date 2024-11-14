#!/usr/bin/python3

import logging
from wayfire import WayfireSocket
from wayfire.extra.wpe import WPE

# Set up logging to track events and errors
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')

# Create Wayfire socket and WPE instance
socket = WayfireSocket()
wpe = WPE(socket)

# Watch for view-mapped events (when a new window is opened)
socket.watch(['view-mapped'])

def create_bottomstack_layout(views):
    """Create a bottomstack layout with master on top and the rest stacked at the bottom."""
    if not views:
        return {}

    master_view = views[0]["view-id"]
    if len(views) == 1:
        return {'view-id': master_view, 'weight': 1}

    # Master view takes the upper portion
    master_split = {'view-id': master_view, 'weight': 0.7}
    
    # The rest of the views are stacked horizontally
    stack_views = [{'view-id': v["view-id"], 'weight': 1 / len(views[1:])} for v in views[1:]]
    
    return {'vertical-split': [master_split, {'horizontal-split': stack_views}]}

def tile_new_view(view):
    """Apply the bottomstack tiling logic when a new view is mapped."""
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

        # Create the bottomstack layout
        all_views.append(view)
        desired_layout = create_bottomstack_layout(all_views)
        socket.set_tiling_layout(wset, wsx, wsy, desired_layout)
        logging.info(f"View {view['id']} added to bottomstack layout.")

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
