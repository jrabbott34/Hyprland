#!/usr/bin/env bash
# Reports caffeine state for Waybar. Reads the lock file written by caffeine-toggle.sh.

LOCK_FILE="/tmp/.caffeine-active"

if [ -f "$LOCK_FILE" ]; then
    echo '{"text": "󰅶 Awake", "tooltip": "Caffeine ON — click to disable", "class": "active"}'
else
    echo '{"text": "󰒲", "tooltip": "Caffeine OFF — click to enable", "class": ""}'
fi
