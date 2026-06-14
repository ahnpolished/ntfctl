#!/bin/bash
# Toggle Notification Center open/closed
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPLESCRIPTS="$(cd "$SCRIPT_DIR/../../.." && pwd)"
exec osascript "$APPLESCRIPTS/ntfctl-center.applescript"
