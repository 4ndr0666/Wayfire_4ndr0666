#!/usr/bin/env bash
# File: ~/.config/wayfire/scripts/bravebeta
# Minimal overhead version

/usr/bin/brave-beta --allowlisted-extension-id=clngdbkpkpeebahjckkjfobafhncgmne \
  --enable-features=UsesOzonePlatform,AllowLegacyMV2Extensions,BraveGoogleSignInPermission,ExtensionManifestV2,FluentOverlayScrollbar,IsolatedWebApps,ToastRefinements,WaylandPerSurfaceScale,WaylandTextInputV3,WaylandUiScale \
  --disable-crash-reporter=,brave,brave-beta &
echo $! > /tmp/brave-beta.pid
