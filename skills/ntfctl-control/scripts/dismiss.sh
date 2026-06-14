#!/bin/bash
# Dismiss the top-most notification
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPLESCRIPTS="$(cd "$SCRIPT_DIR/../../.." && pwd)"
exec osascript "$APPLESCRIPTS/ntfctl-dismiss.applescript"
