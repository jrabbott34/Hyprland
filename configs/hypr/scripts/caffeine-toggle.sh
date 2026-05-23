#!/usr/bin/env bash
# Toggle caffeine mode — kills/restarts hypridle to inhibit sleep.

LOCK_FILE="/tmp/.caffeine-active"

if [ -f "$LOCK_FILE" ]; then
    rm -f "$LOCK_FILE"
    pkill -x hypridle
    hypridle &
    notify-send -i preferences-system-power -u normal \
        "Caffeine Off" "System will sleep normally"
else
    touch "$LOCK_FILE"
    pkill -x hypridle
    notify-send -i preferences-system-power -u normal \
        "Caffeine On" "System will stay awake"
fi
