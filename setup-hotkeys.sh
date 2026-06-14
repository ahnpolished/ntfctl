#!/bin/bash
#  setup-hotkeys.sh
#  ────────────────
#  Quick setup: create AppleScript .app wrappers so you can
#  bind them to global keyboard shortcuts via System Settings.
#
#  Usage:   bash setup-hotkeys.sh
#
#  After running, look in /Applications/ntfctlScripts/
#  Bind those apps to hotkeys in:
#    System Settings → Keyboard → Keyboard Shortcuts → App Shortcuts

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPS_DIR="/Applications/ntfctlScripts"

echo "📦  Installing notification control apps to $APPS_DIR ..."
echo ""

mkdir -p "$APPS_DIR"

declare -A APPS=(
    ["ntfctl Clear"]="ntfctl-clear.applescript"
    ["ntfctl Latest"]="ntfctl-latest.applescript"
    ["ntfctl Dismiss"]="ntfctl-dismiss.applescript"
    ["ntfctl Count"]="ntfctl-count.applescript"
    ["ntfctl DnD"]="ntfctl-dnd.applescript"
    ["ntfctl Center"]="ntfctl-center.applescript"
)

for app_name in "${!APPS[@]}"; do
    script_file="${APPS[$app_name]}"
    app_path="$APPS_DIR/${app_name}.app"
    
    echo "  →  $app_name  ($script_file)"
    
    # Remove old version
    rm -rf "$app_path"
    
    # Create .app bundle structure
    mkdir -p "$app_path/Contents/MacOS"
    mkdir -p "$app_path/Contents/Resources"
    
    # Write the executable launcher
    cat > "$app_path/Contents/MacOS/launcher" <<LAUNCHER
#!/bin/bash
osascript "$SCRIPT_DIR/$script_file"
LAUNCHER
    chmod +x "$app_path/Contents/MacOS/launcher"
    
    # Write Info.plist
    cat > "$app_path/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>launcher</string>
    <key>CFBundleIdentifier</key>
    <string>com.ntfctl.$(echo "$app_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')</string>
    <key>CFBundleName</key>
    <string>$app_name</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSBackgroundOnly</key>
    <true/>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
PLIST
done

echo ""
echo "✅  Done!  Apps installed in $APPS_DIR"
echo ""
echo "── Next Steps ──"
echo ""
echo "1. Grant Accessibility permission:"
echo "   System Settings → Privacy & Security → Accessibility"
echo "   Add & enable the apps (or the terminal app you'll run them from)"
echo ""
echo "2. Bind keyboard shortcuts:"
echo "   System Settings → Keyboard → Keyboard Shortcuts → App Shortcuts"
echo "   Click +, choose an app from $APPS_DIR,"
echo "   leave Menu Title blank, and press your hotkey."
echo ""
echo "   Suggested bindings:"
echo "     ntfctl Clear    →  ⌃⌥⌘C"
echo "     ntfctl Latest   →  ⌃⌥⌘L"
echo "     ntfctl Dismiss  →  ⌃⌥⌘D"
echo "     ntfctl Count    →  ⌃⌥⌘N"
echo "     ntfctl Center   →  ⌃⌥⌘O"
echo "     ntfctl DnD      →  ⌃⌥⌘F"
echo ""
echo "3. For DnD toggle, open Shortcuts.app and verify"
echo "   the 'DND Until I Leave' shortcut exists (or create one)."
