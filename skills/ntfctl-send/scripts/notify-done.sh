#!/bin/bash
# Send a "done" notification with the exit code from the previous command.
# Usage: long-running-command && notify-done.sh "Task name"
TASK="${1:-Task}"
SOUND="${2:-default}"

if [ $? -eq 0 ]; then
    terminal-notifier -title "✅ $TASK Complete" -message "Finished successfully" -sound "$SOUND"
else
    terminal-notifier -title "❌ $TASK Failed" -message "Check output for errors" -sound Basso
fi
