#!/usr/bin/env bash
# Fetches weather from wttr.in and outputs JSON for Waybar custom module.
# Set WEATHER_LOCATION in your shell profile, or it auto-detects by IP.

LOCATION="${WEATHER_LOCATION:-}"

# Condition + temp on one line, full report as tooltip
WEATHER=$(curl -s --max-time 10 "wttr.in/${LOCATION}?format=%c+%t" 2>/dev/null | tr -d '\n')
TOOLTIP=$(curl -s --max-time 10 "wttr.in/${LOCATION}?format=3" 2>/dev/null)

if [[ -z "$WEATHER" || "$WEATHER" == *"Unknown"* ]]; then
    echo '{"text": "󰖑 N/A", "tooltip": "Weather unavailable", "class": ""}'
else
    # Escape quotes for JSON
    TOOLTIP="${TOOLTIP//\"/\'}"
    echo "{\"text\": \"${WEATHER}\", \"tooltip\": \"${TOOLTIP}\", \"class\": \"\"}"
fi
