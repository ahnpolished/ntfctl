#!/bin/bash
# Count pending notifications
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPLESCRIPTS="$(cd "$SCRIPT_DIR/../../.." && pwd)"
exec osascript "$APPLESCRIPTS/ntfctl-count.applescript"
