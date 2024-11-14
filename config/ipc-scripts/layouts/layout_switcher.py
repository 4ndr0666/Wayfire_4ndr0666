#!/usr/bin/python3

import sys
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

def create_list_views(layout):
    """Recursively create a list of views from the tiling layout."""
    if 'view-id' in layout:
        return [(layout['view-id'], layout['geometry']['width'], layout['geometry']['height'])]

    split = 'horizontal-split' if 'horizontal-split' in layout else 'vertical-split'
    list_views = []
    for child in layout[split]:
        list_views += create_list_views(child)
    return list_views

def create_dwindle_layout(views):
    """Recursively apply the dwindle layout."""
    if not views:
        return {}
    
    view_id = views[0][0]
    weight = views[0][1]
    
    if len(views) == 1:
        return {'view-id': view_id, 'weight': 1}
    
    # The first view takes most of the space
    first_split = {'view-id': view_id, 'weight': 0.67}
    # The rest of the views are dwindled
    dwindle_split = create_dwindle_layout(views[1:])
    
    return {'horizontal-split': [first_split, dwindle_split]}

def create_bottomstack_layout(views):
    """Create a bottomstack layout with master on top and the rest stacked at the bottom."""
    if not views:
        return {}

    master_view = views[0][0]
    if len(views) == 1:
        return {'view-id': master_view, 'weight': 1}

    # Master view takes the upper portion
    master_split = {'view-id': master_view, 'weight': 0.7}
    
    # The rest of the views are stacked horizontally
    stack_views = [{'view-id': v[0], 'weight': 1 / len(views[1:])} for v in views[1:]]
    
    return {'vertical-split': [master_split, {'horizontal-split': stack_views}]}

def create_masterstack_layout(views):
    """Create a masterstack layout with the main view on the left and the rest stacked vertically on the right."""
    if not views:
        return {}

    main_view = views[0][0]
    weight_main = views[0][1]
    if len(views) == 1:
        return {'view-id': main_view, 'weight': 1}

    # The rest of the views are stacked on the right
    stack_views = [{'view-id': v[0], 'weight': v[1]} for v in views[1:]]

    return {
        'vertical-split': [
            {'view-id': main_view, 'weight': weight_main},
            {'horizontal-split': stack_views}
        ]
    }

def tile_new_view(view, layout_name):
    """Apply the specified layout when a new view is mapped."""
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

        all_views.append((view["id"], view["geometry"]["width"], view["geometry"]["height"]))

        if layout_name == "dwindle":
            desired_layout = create_dwindle_layout(all_views)
            logging.info(f"View {view['id']} added to dwindle layout.")
        elif layout_name == "bottomstack":
            desired_layout = create_bottomstack_layout(all_views)
            logging.info(f"View {view['id']} added to bottomstack layout.")
        elif layout_name == "masterstack":
            desired_layout = create_masterstack_layout(all_views)
            logging.info(f"View {view['id']} added to masterstack layout.")
        else:
            logging.error(f"Invalid layout: {layout_name}")
            return

        socket.set_tiling_layout(wset, wsx, wsy, desired_layout)

    except Exception as e:
        logging.error(f"Failed to tile view {view['id']}: {e}")

def main(layout_name):
    """Main function to handle the layout switching."""
    while True:
        try:
            msg = socket.read_next_event()
            if "event" in msg:
                view = msg["view"]
                if view["type"] == "toplevel" and view["parent"] == -1:
                    tile_new_view(view, layout_name)
        except Exception as e:
            logging.error(f"Error reading event: {e}")

# Script entry point
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: layout_switcher.py <layout>")
        sys.exit(1)

    layout_name = sys.argv[1]
    main(layout_name)
