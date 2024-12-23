[alpha]
min_value = 1.000000
modifier = <alt> <super> 

[animate]
close_animation = zoom
duration = 200ms circle
enabled_for = (type is "toplevel" | (type is "x-or" & focusable is true) | app_id is "wofi" | app_id is "waybar" | app_id contains "Rofi")
fade_duration = 200ms circle
fade_enabled_for = none
fire_color = \#B22303FF
fire_duration = 300ms circle
fire_enabled_for = none
fire_particle_size = 16.000000
fire_particles = 2000
open_animation = zoom
random_fire_color = false
startup_duration = 200ms circle
zoom_duration = 200ms circle
zoom_enabled_for = (type is "toplevel" | (type is "x-or" & focusable is true) | app_id is "wofi" | app_id is "waybar" | app_id contains "Rofi")

[autostart]
0_environment = dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP=wayfire
apply_themes = ~/.config/wayfire/scripts/gtkthemes &>/dev/null &
autostart_wf_shell = false
clipman-restore = clipman restore
clipman-store = wl-paste -t text --watch clipman store
dex = dex -a -s /etc/xdg/autostart/:~/.config/autostart/:~/.config/shellz/run-wayfire
gnome-keyring = gnome-keyring-daemon --daemonize --start --components=gpg,pkcs11,secrets,ssh
idle = swayidle before-sleep ~/.config/wayfire/scripts/lockscreen
nm = nm-applet --indicator
notifications = ~/.config/wayfire/scripts/notifications &>/dev/null &
outputs = kanshi
polkit-gnome = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#portal = /usr/libexec/xdg-desktop-portal
portal = /usr/lib/xdg-desktop-portal --replace & /usr/lib/xdg-desktop-portal-wlr
pactl = pactl load-module module-switch-on-connect

set_wallpaper = ~/.config/wayfire/scripts/wallpaper &
start_notify = ~/.config/wayfire/scripts/notifications &
start_statusbar = ~/.config/wayfire/scripts/statusbar &

[command]
binding_alacritty = <super> KEY_ENTER
binding_clipman = <alt> KEY_F1
binding_colorpicker = <super> KEY_P
binding_cutter = <super> KEY_F5
binding_dmenuhandler = <super> KEY_F10
binding_dmenurecord = <super> KEY_F12
binding_editor = <super> KEY_E
binding_files = <super> KEY_F
binding_jdownloader = <super> KEY_F7
binding_joshuto = <super> KEY_F2
binding_kill = <super> KEY_ESC
binding_launcher = <super> KEY_D
binding_lockscreen = <ctrl> <alt> KEY_L
binding_logout = <super> KEY_X
binding_lossless = <super> KEY_F6
binding_media = <super> KEY_F11
binding_media-play-pause = KEY_PLAYPAUSE
binding_media-stop = KEY_STOPCD
binding_micro = <super> KEY_F3
binding_min = <super> KEY_M
binding_mute = KEY_MUTE
binding_nm = <super> KEY_N
binding_nvim = <super> KEY_F4
binding_oom = <super> KEY_0
binding_pacui = <super> KEY_F9
binding_playwithmpv = <super> KEY_F1
binding_runner = <super> KEY_R
binding_screenshot = <super> KEY_SYSRQ
binding_screenshot_10 = <shift> KEY_SYSRQ
binding_screenshot_5 = <alt> KEY_SYSRQ
binding_screenshot_interactive = KEY_SYSRQ
binding_searchmaster = <alt> KEY_9
binding_shots = <super> KEY_S
binding_st = <super> <shift> KEY_ENTER
binding_theme = <super> <shift> KEY_C
binding_web = <super> KEY_W
#binding_dwindle = <super> KEY_Y
#binding_masterstack = <super> KEY_T

command_alacritty = ~/.config/wayfire/scripts/alacritty 
command_clipman = clipman pick -t wofi
command_colorpicker = ~/.config/wayfire/scripts/colorpicker
command_cutter = flawless-cut
command_dmenuhandler = ~/.local/bin/dmenuhandler
command_dmenurecord = ~/.local/bin/dmenurecord
command_editor = lite-xl
command_files = thunar
command_jdownloader = jdownloader
command_joshuto = alacritty -e joshuto
command_kill = wf-kill
command_launcher = ~/.config/wayfire/scripts/rofi_launcher
command_lockscreen = ~/.config/wayfire/scripts/lockscreen
command_logout = ~/.config/wayfire/scripts/rofi_powermenu
command_lossless = losslesscut
command_media = ~/.local/bin/dmenumedia
command_media-next = playerctl next
command_media-play-pause = playerctl play-pause
command_media-prev = playerctl previous
command_media-stop = playerctl stop
command_micro = alacritty -e micro
command_min = min-browser
command_mute = pactl set-sink-mute @DEFAULT_SINK@ toggle
command_nm = ~/.config/wayfire/scripts/rofi_network
command_nvim = alacritty -e nvim
command_oom = sudo kill -USR1 $(pgrep earlyoom)
command_pacui = alacritty -e pacui
command_playwithmpv = ~/.local/bin/pwmpv-toggle
command_runner = ~/.config/wayfire/scripts/rofi_runner
command_screenshot = ~/.config/wayfire/scripts/rofi_screenshot
command_screenshot_10 = ~/.config/wayfire/scripts/screenshot --in10
command_screenshot_5 = ~/.config/wayfire/scripts/screenshot --in5
command_screenshot_interactive = ~/.config/wayfire/scripts/screenshot --area
command_searchmaster = alacritty -e /usr/local/bin/searchmaster.py
command_shots = ~/.config/wayfire/scripts/rofi_screenshot
command_st = ~/.config/wayfire/scripts/st 
command_theme = ~/.config/wayfire/theme/theme.sh --pywal
command_volume_down = pactl set-sink-volume @DEFAULT_SINK@ -5%
command_volume_up = pactl set-sink-volume @DEFAULT_SINK@ +5%
command_web = brave-beta --ozone-platform=wayland & 
#brave
#command_dwindle = ~/.config/wayfire/scripts/dwindle.sh
#command_masterstack = ~/.config/wayfire/scripts/masterstack.sh

repeatable_binding_media-next = KEY_NEXTSONG
repeatable_binding_media-prev = KEY_PREVIOUSSONG
repeatable_binding_volume_down = KEY_VOLUMEDOWN
repeatable_binding_volume_up = KEY_VOLUMEUP

[core]
background_color = 0.059 0.059 0.105 1.0
close_top_view = <super> KEY_Q
focus_button_with_modifiers = false
focus_buttons = BTN_LEFT
focus_buttons_passthrough = true
max_render_time = -1
plugins = alpha animate autostart command decoration expo fast-switcher foreign-toplevel grid move place resize vswitch window-rules wrot zoom scale wm-actions winzoom scale-title-filter focus-request follow-focus force-fullscreen mag session-lock simple-tile hide-cursor wf-kill workspace-names ipc-rules ipc-server stipc preserve-output ipc
preferred_decoration_mode = server
transaction_timeout = 100
vheight = 3
vwidth = 3
xwayland = true

[decoration]
active_color = 0.576 0.380 0.416 1.0
border_size = 2
button_order = minimize maximize close
font = MesloLGS NF
ignore_views = none
inactive_color = 0.094 0.094 0.168 1.0
title_height = 0

[expo]
background = 0.059 0.059 0.105 1.0
duration = 200ms circle
inactive_brightness = 0.700000
keyboard_interaction = true
offset = 10
select_workspace_1 = KEY_1
select_workspace_2 = KEY_2
select_workspace_3 = KEY_3
select_workspace_4 = KEY_4
select_workspace_5 = KEY_5
select_workspace_6 = KEY_6
select_workspace_7 = KEY_7
select_workspace_8 = KEY_8
select_workspace_9 = KEY_9
toggle = <super>  | BTN_MIDDLE
transition_length = 150

[fast-switcher]
activate = <super> KEY_TAB
activate_backward =
inactive_alpha = 0.700000

#[fisheye]
#radius = 450.000000
#toggle = <ctrl> <super> BTN_LEFT
#zoom = 7.000000

#[focus-change]
#cross-output = false
#cross-workspace = false
#down = <shift> <super> KEY_DOWN
#grace-down = 1
#grace-left = 1
#grace-right = 1
#grace-up = 1
#left = <shift> <super> KEY_LEFT
#raise-on-change = true
#right = <shift> <super> KEY_RIGHT
#scan-height = 0
#scan-width = 0
#up = <shift> <super> KEY_UP

[focus-request]
auto_grant_focus = true

[follow-focus]
change_output = true
change_view = true
focus_delay = 250
raise_on_top = true
threshold = 10

[force-fullscreen]
constrain_pointer = false
constraint_area = view
key_toggle_fullscreen = <shift> <super> KEY_F
preserve_aspect = true
transparent_behind_views = true
x_skew = 0.000000
y_skew = 0.000000

[foreign-toplevel]


[grid]
#
# ⇱ ↑ ⇲   │ 7 8 9
# ← f →   │ 4 5 6
# ⇱ ↓ ⇲ d │ 1 2 3 0
# ‾   ‾
slot_b = <super> KEY_J | <super> KEY_KP2
slot_bl = <super> KEY_KP1
slot_br = <super> KEY_KP3
slot_c = <super> KEY_UP | <super> KEY_KP5
slot_l = <super> KEY_H | <super> KEY_KP4
slot_r = <super> KEY_L | <super> KEY_KP6
slot_t = <super> KEY_K | <super> KEY_KP8
slot_tl = <super> KEY_KP7
slot_tr = <super> KEY_KP9
type = none
restore = <super> KEY_DOWN | <super> KEY_KP0
duration = 150
[hide-cursor]
hide_delay = 1000
toggle = <ctrl> <super> KEY_H

[input]
click_method = default
## Cursor configuration
cursor_theme = Breeze_Hacked
cursor_size = 24
disable_touchpad_while_mouse = false
disable_touchpad_while_typing = false
drag_lock = false
gesture_sensitivity = 1.000000
kb_capslock_default_state = false
kb_numlock_default_state = true
kb_repeat_delay = 300
kb_repeat_rate = 50
## Mouse / Touchpad (libinput configuration)
left_handed_mode = false
middle_emulation = false
modifier_binding_timeout = 400
# --- // Other profiles contain trackers by nature and use mem, so kill it.
#mouse_accel_profile = flat
# --- //
mouse_accel_profile = default
mouse_cursor_speed = 0.000000
mouse_natural_scroll = false
mouse_scroll_speed = 1.000000
natural_scroll = false
scroll_method = default
tablet_motion_mode = default
tap_to_click = true
touchpad_accel_profile = default
touchpad_cursor_speed = 0.000000
touchpad_scroll_speed = 0.000000
xkb_layout = us
xkb_model = pc105
xkb_options = caps:escape
xkb_rules = evdev
xkb_variant = 
[input-method-v1]
enable_text_input_v1 = true
enable_text_input_v3 = true

[ipc]

[ipc-rules]

[mag]
default_height = 800
toggle = <shift> <super> KEY_M
zoom_level = 100

[move]
activate = <super> BTN_LEFT
enable_snap = true
enable_snap_off = true
join_views = false
preview_base_border = \#15FFFF3A
preview_base_color = \#222222AA
preview_border_width = 3
quarter_snap_threshold = 50
snap_off_threshold = 10
snap_threshold = 10
workspace_switch_after = -1


## Output configuration ─────────────────────────────────────────────────────────

# Example configuration:
#
#~ Laptop screen, mode: 1920x1080, scale: 1
# [output:eDP-1]
# mode = 1920x1080@60000
# position = 0,0
# transform = normal
# scale = 1.000000
#
#~ External monitor, mode: 1920x1080, position: right of laptop, scale: 1.5
#[output:HDMI-A-1]
[output]
depth = 8
mode = 1920x1080@60000
position = auto
scale = 1.000000
transform = normal
vrr = false

[place]
fullscreen_output = current
keep_in_area = true
mode = center
new_view = center
type = float

[preserve-output]
last_output_focus_timeout = 10000

[resize]
activate = <super> BTN_RIGHT
activate_preserve_aspect = <ctrl> <super> BTN_RIGHT

[scale]
allow_zoom = false
bg_color = \#1A1A1AE6
close_on_new_view = false
duration = 400
inactive_alpha = 0.750000
include_minimized = true
interact = false
middle_click_close = false
minimized_alpha = 0.450000
outer_margin = 0
spacing = 50
text_color = \#15FFFFFF
title_font_size = 16
title_overlay = all
title_position = center
toggle = <super> KEY_V
toggle_all = <shift> <super> KEY_V | hotspot bottom-left 100x10 1000

[scale-title-filter]
bg_color = \#00000080
case_sensitive = false
font_size = 30
overlay = true
share_filter = false
text_color = \#CCCCCCCC

[session-lock]

[simple-tile]
# --- // True keeps fullscreen state on when changing focus to another window
keep_fullscreen_on_adjacent = true
# --- //
animation_duration = 0
button_move = <super> BTN_LEFT
button_resize = <super> BTN_RIGHT
inner_gap_size = 5


preview_base_border = \#404080CC
preview_base_color = \#8080FF80
preview_border_width = 3

#[simple-tile layouts]
# --- //Dwindle_layout
#split_ratio = 0.67  # Master area takes up 2/3 of the screen
#key_focus_above = <super> KEY_UP
#key_focus_below = <super> KEY_DOWN
#key_focus_left = <super> KEY_LEFT
#key_focus_right = <super> KEY_RIGHT
#key_toggle = <super> KEY_SPACE

# --- //Normal_layout
split_ratio = 0.500000
key_focus_above = <super> KEY_K
key_focus_below = <super> KEY_J
key_focus_left = <super> KEY_H
key_focus_right = <super> KEY_L
key_toggle = <super> KEY_SPACE
outer_horiz_gap_size = 0
outer_vert_gap_size = 0
tile_by_default = all
#(type is "toplevel" & focusable is true) | (type is "x-or" & focusable is true)


# --- //My First Layout
#key_focus_above = <super> KEY_UP
#key_focus_below = <super> KEY_DOWN
#key_focus_left = <super> KEY_LEFT
#key_focus_right = <super> KEY_RIGHT
#key_toggle = <super> KEY_SPACE
#outer_horiz_gap_size = 10
#outer_vert_gap_size = 10
#tile_by_default = (type is "x-or" & focusable is false) | (type is "toplevel" & focusable is false)"
[vswitch]
duration = 20
background = 0.059 0.059 0.105 1.0
gap = 20
background = 0.059 0.059 0.105 1.0
wraparound = false
# Switches to workspace left/down/up/right
binding_down = <ctrl> <super> KEY_DOWN
binding_last = <ctrl> <super> KEY_L
binding_left = <ctrl> <super> KEY_LEFT
binding_right = <ctrl> <super> KEY_RIGHT
binding_up = <ctrl> <super> KEY_UPbinding_1 = <super> KEY_1
with_win_down = <ctrl> <shift> <super> KEY_DOWN
with_win_last = 
with_win_left = <ctrl> <shift> <super> KEY_LEFT
with_win_right = <ctrl> <shift> <super> KEY_RIGHT
with_win_up = <ctrl> <shift> <super> KEY_UP
wraparound = false# Send the focused window to the workspace left/down/up/right
# Send the focused window to the workspace left/down/up/right
send_win_down = <alt> <ctrl> <super> KEY_DOWN
send_win_last = 
send_win_left = <alt> <ctrl> <super> KEY_LEFT
send_win_right = <alt> <ctrl> <super> KEY_RIGHT
send_win_up = <alt> <ctrl> <super> KEY_UP
# Binding to go to workspace N
binding_1 = <super> KEY_1
binding_2 = <super> KEY_2
binding_3 = <super> KEY_3
binding_4 = <super> KEY_4
binding_5 = <super> KEY_5
binding_6 = <super> KEY_6
binding_7 = <super> KEY_7
binding_8 = <super> KEY_8
binding_9 = <super> KEY_9
# Binding to go to workspace N with currently focused window
with_win_1 = <super> <shift> KEY_1
with_win_2 = <super> <shift> KEY_2
with_win_3 = <super> <shift> KEY_3
with_win_4 = <super> <shift> KEY_4
with_win_5 = <super> <shift> KEY_5
with_win_6 = <super> <shift> KEY_6
with_win_7 = <super> <shift> KEY_7
with_win_8 = <super> <shift> KEY_8
with_win_9 = <super> <shift> KEY_9
# Binding to move focused window to workspace N
send_win_1 = <super> <ctrl> KEY_1
send_win_2 = <super> <ctrl> KEY_2
send_win_3 = <super> <ctrl> KEY_3
send_win_4 = <super> <ctrl> KEY_4
send_win_5 = <super> <ctrl> KEY_5
send_win_6 = <super> <ctrl> KEY_6
send_win_7 = <super> <ctrl> KEY_7
send_win_8 = <super> <ctrl> KEY_8
send_win_9 = <super> <ctrl> KEY_9
[wsets]
label_duration = 5000
# Binding to switch to workspace set N
wset_1 = <super> <alt> KEY_1
wset_2 = <super> <alt> KEY_2
wset_3 = <super> <alt> KEY_3
# Binding to send the currently focused window to workspace set N
send_to_wset_1 = <super> <shift> <alt> KEY_1
send_to_wset_2 = <super> <shift> <alt> KEY_2
send_to_wset_3 = <super> <shift> <alt> KEY_3

[wf-kill]

[wf-info]

[window-rules]
rule_001 = on created if app_id is "thunar" then set geometry 236 83 886 552
rule_002 = on created if app_id is "thunar" then set alpha 0.8
rule_0021 = on created if title contains "Rename" then set geometry 485 241 418 215
rule_0022 = on created if title contains "Properties" then set geometry 378 91 572 541
rule_004 = on created if title is "Downloads - Thunar" then assign_workspace 2 0
rule_005 = on created if title is "media - Thunar" then assign_workspace 2 2
rule_006 = on created if app_id is "Alacritty" then set geometry 285 55 1767 1229
rule_007 = on created if app_id is "Alacritty" then set alpha 0.8
rule_012 = on created if app_id is "mpv" then set geometry 1304 717 812 476
rule_013 = on created if app_id is "mpv" then assign_workspace 0 0
rule_014 = on created if app_id is "brave-browser-beta" then set geometry 241 58 1865 1217
rule_015 = on created if app_id is "brave-browser-beta" then set alpha 1.0
rule_016 = on created if app_id is "brave-browser-beta" then assign_workspace 1 0
rule_020 = on created if app_id is "lite-xl" then set geometry 1121 53 1095 1214
rule_021 = on created if app_id is "lite-xl" then set alpha 0.8
rule_022 = on created if app_id is "lite-xl" then assign_workspace 2 0
rule_026 = on created if app_id is "nwg-look" then set geometry 270 129 821 519
rule_027 = on created if app_id is "nwg-look" then set alpha 0.8
rule_028 = on created if app_id is "nwg-look" then assign_workspace 0 1
rule_032 = on created if app_id is "pavucontrol" then set geometry 280 710 800 500
rule_033 = on created if app_id is "pavucontrol" then set alpha 0.9
rule_034 = on created if app_id is "pavucontrol" then assign_workspace 0 1
rule_042 = on created if app_id is "foot" then set geometry 239 637 803 527
rule_043 = on created if app_id is "foot" then set alpha 0.8
rule_044 = on created if app_id is "foot" then assign_workspace 2 0
rule_051 = on created if app_id is "pcmanfm" then move 270 100
rule_052 = on created if app_id is "pcmanfm" then assign_workspace 2 2
rule_055 = on created if app_id is "Conky" then set sticky
rule_068 = on created if app_id is "io.github.celluloid_player.Celluloid" then set geometry 1231 677 138 512
rule_075 = on created if title is "Picture-in-Picture" then set always_on_top
rule_076 = on created if app_id is "st" then set geometry 285 55 1767 1229
rule_077 = on created if app_id is "st" then set alpha 0.8

[winzoom]
dec_x_binding = <ctrl> <super> KEY_LEFT
dec_y_binding = <ctrl> <super> KEY_UP
inc_x_binding = <ctrl> <super> KEY_RIGHT
inc_y_binding = <ctrl> <super> KEY_DOWN
modifier = <ctrl> <super> 
nearest_filtering = false
preserve_aspect = true
zoom_step = 0.100000

[resize]
activate = <super> BTN_RIGHT

[wm-actions]
minimize = <shift> <super> KEY_F5
send_to_back = <shift> <super> KEY_F9
toggle_always_on_top = <shift> <super> KEY_F7
toggle_fullscreen = <shift> <super> KEY_F
toggle_maximize = <shift> <super> KEY_F6
toggle_showdesktop = <shift> <super> KEY_F10
toggle_sticky = <shift> <super> KEY_F8


[workarounds]
# --- // False allows the main window to be focused even it it has a dialog
#all_dialogs_modal = false
all dialogs modal = true
# --- // True allows wayfire to override max_render_time
dynamic_repaint_delay = false
# --- // True forces the compositor-preferred decor over client xdg-decorations
force_preferred_decoration_mode = false
app_id_mode = stock
discard_command_output = true
enable_input_method_v2 = false
enable_opaque_region_damage_optimizations = false
enable_so_unloading = false
remove_output_limits = false
use_external_output_configuration = false

[workspace-names]
background_color = 0.059 0.059 0.105 1.0
background_radius = 30.000000
display_duration = 500
font = sans-serif
margin = 0
position = center
show_option_names = false
text_color = \#FFFFFFFF

[wrot]
activate = <shift> <super> BTN_LEFT
activate-3d = <shift> <super> BTN_RIGHT
invert = false
reset = <shift> <super> KEY_R
reset-one = 
reset_radius = 25.000000
sensitivity = 24


[xdg-activation]

[zoom]
activate = <ctrl> <alt> BTN_LEFT
background = 0.059 0.059 0.105 1.0
background_mode = simple
deform = 0
initial_animation = 350
interpolation_method = 0
light = true
modifier = <ctrl> <super> 
rotate_left = <ctrl> <alt> KEY_LEFT
rotate_right = <ctrl> <alt> KEY_RIGHT
smoothing_duration = 300
speed = 0.010000
speed_spin_horiz = 0.02
speed_spin_vert = 0.02
speed_zoom = 0.07
zoom = 0.1
