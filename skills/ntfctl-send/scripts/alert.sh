#!/bin/bash
# Play a system alert sound and flash the screen.
# Usage: alert.sh [sound_name]
SOUND="${1:-Ping}"
afplay "/System/Library/Sounds/${SOUND}.aiff"
