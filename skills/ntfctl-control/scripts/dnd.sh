#!/bin/bash
# Toggle Do Not Disturb
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPLESCRIPTS="$(cd "$SCRIPT_DIR/../../.." && pwd)"
exec osascript "$APPLESCRIPTS/ntfctl-dnd.applescript"
