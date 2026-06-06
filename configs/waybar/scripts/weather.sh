#!/usr/bin/env bash
# Fetches weather from wttr.in and outputs JSON for Waybar custom module.
# Set WEATHER_LOCATION in your shell profile, or leave blank to auto-detect.

LOCATION="${WEATHER_LOCATION:-Louisville+KY}"
LOCATION_ENC="${LOCATION// /+}"

# Current conditions (display text)
WEATHER=$(curl -s --max-time 10 -A "curl" "wttr.in/${LOCATION_ENC}?format=%c+%t" 2>/dev/null | tr -d '\n' | tr -s ' ')

if [[ -z "$WEATHER" || "$WEATHER" == *"Unknown"* ]]; then
    echo '{"text": "󰖑 N/A", "tooltip": "Weather unavailable", "class": ""}'
    exit 0
fi

# Full forecast via JSON API
JSON=$(curl -s --max-time 10 -A "curl" "wttr.in/${LOCATION_ENC}?format=j1" 2>/dev/null)

if [[ -z "$JSON" ]]; then
    jq -cn --arg text "$WEATHER" '{"text": $text, "tooltip": "Forecast unavailable", "class": ""}'
    exit 0
fi

# Parse current conditions
DESC=$(echo "$JSON"   | jq -r '.current_condition[0].weatherDesc[0].value')
TEMP=$(echo "$JSON"   | jq -r '.current_condition[0].temp_F')
FEELS=$(echo "$JSON"  | jq -r '.current_condition[0].FeelsLikeF')
HUMID=$(echo "$JSON"  | jq -r '.current_condition[0].humidity')
WIND=$(echo "$JSON"   | jq -r '.current_condition[0].windspeedMiles')
UV=$(echo "$JSON"     | jq -r '.current_condition[0].uvIndex')

# 3-day forecast
DAY0=$(echo "$JSON" | jq -r '.weather[0] | "\(.date)  \(.hourly[4].weatherDesc[0].value)  High \(.maxtempF)°F / Low \(.mintempF)°F"')
DAY1=$(echo "$JSON" | jq -r '.weather[1] | "\(.date)  \(.hourly[4].weatherDesc[0].value)  High \(.maxtempF)°F / Low \(.mintempF)°F"')
DAY2=$(echo "$JSON" | jq -r '.weather[2] | "\(.date)  \(.hourly[4].weatherDesc[0].value)  High \(.maxtempF)°F / Low \(.mintempF)°F"')

TOOLTIP="${DESC}  ${TEMP}°F  (Feels like ${FEELS}°F)
Humidity: ${HUMID}%  |  Wind: ${WIND} mph  |  UV: ${UV}

3-Day Forecast
${DAY0}
${DAY1}
${DAY2}"

jq -cn --arg text "$WEATHER" --arg tooltip "$TOOLTIP" \
    '{"text": $text, "tooltip": $tooltip, "class": ""}'
