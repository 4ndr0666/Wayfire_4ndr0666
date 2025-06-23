#!/usr/bin/env bash
# shellcheck disable=all
# Interactive, Idempotent Setup for X11/Wayland + xrun
# Use: ./install_xwayland_wrapper.sh install|uninstall

set -e

log_info()    { echo "[INFO] $1"; }
log_warn()    { echo "[WARN] $1"; }
log_error()   { echo "[ERROR] $1" >&2; }

# --- PROMPT USER ---

get_target_user() {
    local input
    echo
    log_info "=== X11/Xwayland Setup: User Selection ==="
    log_info "This script needs to know which username to permit for X server access (for Polkit rule)."
    log_info "If unsure, just press [Enter] to use your current username: '$(id -un)'."
    read -r -p "[Xwayland Setup] Enter permitted username [default: $(id -un)]: " input    
    if [[ -z "$input" ]]; then
        echo "$(id -un)"
    else
        echo "$input"
    fi
}

# --- INSTALL FUNCTIONS ---

configure_xwrapper() {
    local file="/etc/X11/Xwrapper.config"
    local content="allowed_users=anybody
needs_root_rights=yes
"
    if ! sudo test -f "$file" || ! sudo cmp -s <(echo "$content") "$file"; then
        log_info "Configuring $file (allows any user to start X11 server)..."
        echo "$content" | sudo tee "$file" > /dev/null
        log_info "$file configured."
    else
        log_info "$file already configured; skipping."
    fi
}

create_polkit_rule() {
    local user1="$1"
    local user2="root"
    local file="/etc/polkit-1/rules.d/50-x11-access.rules"
    local content="// $file
polkit.addRule(function(action, subject) {
    if (action.id == \"org.freedesktop.DisplayManager.XServer\" &&
        (subject.user == \"$user1\" || subject.user == \"$user2\")) {
        return polkit.Result.YES;
    }
});
"
    if ! sudo test -f "$file" || ! sudo cmp -s <(echo "$content") "$file"; then
        log_info "Writing polkit rule at $file (permits users '$user1' and '$user2' to start X server via DM)..."
        echo "$content" | sudo tee "$file" > /dev/null
        log_info "Polkit rule written."
    else
        log_info "Polkit rule already in place; skipping."
    fi
}

create_xrun_script() {
    local file="$HOME/.local/bin/xrun"
    local content='#!/usr/bin/env bash
# Smart launcher for X11/Wayland apps, with safe root GUI support via xhost

log_info()  { echo "[INFO] $1"; }
log_error() { echo "[ERROR] $1" >&2; }

detect_env() {
    if [[ ${XDG_SESSION_TYPE:-} == "wayland" ]]; then
        export GDK_BACKEND=wayland,x11
        export QT_QPA_PLATFORM=wayland
    else
        export GDK_BACKEND=x11
        export QT_QPA_PLATFORM=xcb
    fi
}

grant_root_xwayland()   { command -v xhost &>/dev/null && xhost +SI:localuser:root; }
revoke_root_xwayland()  { command -v xhost &>/dev/null && xhost -SI:localuser:root; }

run_with_env_vars() {
    detect_env
    "$@"
}

run_as_root() {
    grant_root_xwayland
    if [[ $EUID -eq 0 ]]; then
        "$@"
    else
        sudo -E -A "$@"
    fi
    revoke_root_xwayland
}

main() {
    if [[ $# -eq 0 ]]; then
        log_error "No application specified to run."
        exit 1
    fi
    if [[ $1 == "--root" ]]; then
        shift
        if [[ $# -eq 0 ]]; then
            log_error "No application specified to run as root."
            exit 1
        fi
        run_as_root "$@"
    else
        run_with_env_vars "$@"
    fi
}

main "$@"
'
    if [ ! -f "$file" ] || ! cmp -s <(echo "$content") "$file"; then
        log_info "Installing/updating 'xrun' at $file..."
        mkdir -p "$(dirname "$file")"
        echo "$content" > "$file"
        chmod +x "$file"
        log_info "'xrun' installed/updated."
    else
        log_info "'xrun' is already up to date; skipping."
    fi
}

# --- UNINSTALL FUNCTIONS ---

remove_xwrapper() {
    local file="/etc/X11/Xwrapper.config"
    if sudo test -f "$file"; then
        log_info "Removing $file..."
        sudo rm -f "$file"
        log_info "$file removed."
    else
        log_info "$file does not exist; skipping."
    fi
}

remove_polkit_rule() {
    local file="/etc/polkit-1/rules.d/50-x11-access.rules"
    if sudo test -f "$file"; then
        log_info "Removing $file..."
        sudo rm -f "$file"
        log_info "Polkit rule removed."
    else
        log_info "$file does not exist; skipping."
    fi
}

remove_xrun_script() {
    local file="$HOME/.local/bin/xrun"
    if [ -f "$file" ]; then
        log_info "Removing $file..."
        rm -f "$file"
        log_info "'xrun' removed."
    else
        log_info "'xrun' does not exist; skipping."
    fi
}

# --- MAIN ---

show_usage() {
    echo "Usage: $0 install|uninstall"
}

if [[ $# -lt 1 ]]; then
    show_usage
    exit 1
fi

case "$1" in
    install)
        if [ -t 0 ]; then
            user="$(get_target_user)"
        else
            user="${TARGET_USER:-$(id -un)}"
            log_info "No TTY detected; using '${user}' for polkit rule."
        fi
        configure_xwrapper
        create_polkit_rule "$user"
        create_xrun_script
        log_info ""
        log_info "Setup completed."
        log_info "Usage:"
        log_info "  xrun <app>           # Run as user with session-correct X11/Wayland env"
        log_info "  xrun --root <app>    # Run as root with safe (temporary) Xwayland access"
        log_warn ""
        log_warn "SECURITY: Xwrapper allows broad X11 access; polkit rule only permits your user and root to start X via DM."
        log_warn "'xrun --root' grants root Xwayland access only during runtime."
        log_info ""
        ;;
    uninstall)
        remove_xwrapper
        remove_polkit_rule
        remove_xrun_script
        log_info ""
        log_info "Uninstall completed. System reverted to previous state."
        ;;
    *)
        show_usage
        exit 1
        ;;
esac
