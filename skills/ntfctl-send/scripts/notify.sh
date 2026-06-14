#!/bin/bash
# Send a macOS notification.
# Usage: notify.sh "Title" "Message" [sound]
TITLE="${1:-Agent}"
MESSAGE="${2:-Task complete}"
SOUND="${3:-default}"

if command -v terminal-notifier &>/dev/null; then
    exec terminal-notifier -title "$TITLE" -message "$MESSAGE" -sound "$SOUND"
else
    exec osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"$SOUND\""
fi
