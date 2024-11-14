#!/usr/bin/python3

import logging
from wayfire import WayfireSocket
from wayfire.extra.wpe import WPE

# Set up logging to track events and errors
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Create Wayfire socket and WPE instance
socket = WayfireSocket()
wpe = WPE(socket)

# Watch for view-mapped events (new window opened)
socket.watch(['view-mapped'])

def create_list_views(layout):
    """Recursively create a list of views from the tiling layout."""
    if 'view-id' in layout:
        return [(layout['view-id'], layout['geometry']['width'], layout['geometry']['height'])]

    split = 'horizontal-split' if 'horizontal-split' in layout else 'vertical-split'
    list_views = []
    for child in layout[split]:
        list_views += create_list_views(child)
    return list_views

def tile_new_view(view):
    """Apply the master-stack tiling logic when a new view is mapped."""
    try:
        output = socket.get_output(view["output-id"])
        wset = output['wset-index']
        wsx = output['workspace']['x']
        wsy = output['workspace']['y']
        layout = socket.get_tiling_layout(wset, wsx, wsy)
        all_views = create_list_views(layout)

        if not all_views or (len(all_views) == 1 and all_views[0][0] == view["id"]):
            desired_layout = { 'vertical-split': [ {'view-id': view["id"], 'weight': 1} ]}
            socket.set_tiling_layout(wset, wsx, wsy, desired_layout)
            logging.info(f"Single view {view['id']} set in full layout.")
            return

        main_view = all_views[0][0]
        weight_main = all_views[0][1]
        stack_views_old = [v for v in all_views[1:] if v[0] != view["id"]]
        weight_others = max([v[1] for v in stack_views_old], default=output['workarea']['width'] - weight_main)

        if main_view == view["id"] or not stack_views_old:
            desired_layout = { 'vertical-split': [ {'view-id': main_view, 'weight': 2}, {'view-id': view["id"], 'weight': 1} ]}
            socket.set_tiling_layout(wset, wsx, wsy, desired_layout)
            logging.info(f"View {view['id']} added to stack with main view {main_view}.")
            return

        stack = [{'view-id': v[0], 'weight': v[2]} for v in stack_views_old]
        stack.append({'view-id': view["id"], 'weight': sum([v[2] for v in stack_views_old]) / len(stack_views_old)})

        desired_layout = {
            'vertical-split': [
                {'weight': weight_main, 'view-id': main_view},
                {'weight': weight_others, 'horizontal-split': stack}
            ]
        }

        socket.set_tiling_layout(wset, wsx, wsy, desired_layout)
        logging.info(f"View {view['id']} added to stack with main view {main_view}.")

    except Exception as e:
        logging.error(f"Failed to tile view {view['id']}: {e}")

# Main event loop to handle view-mapped events
while True:
    try:
        msg = socket.read_next_event()
        if "event" in msg and "view" in msg:
            view = msg["view"]
            if view["type"] == "toplevel" and view["parent"] == -1:
                tile_new_view(view)
    except Exception as e:
        logging.error(f"Error reading event: {e}")
