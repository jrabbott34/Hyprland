#!/usr/bin/env bash
# Fetches weather from wttr.in and outputs JSON for Waybar custom module.
# Set WEATHER_LOCATION in your shell profile, or leave blank to auto-detect.

LOCATION="${WEATHER_LOCATION:-Louisville+KY}"
LOCATION_ENC="${LOCATION// /+}"

# Full forecast via JSON API
JSON=$(curl -s --max-time 10 -A "curl" "wttr.in/${LOCATION_ENC}?format=j1" 2>/dev/null)

if [[ -z "$JSON" ]]; then
    echo '{"text": "󰖑 N/A", "tooltip": "Weather unavailable", "class": ""}'
    exit 0
fi

# Map weather code to nerd font icon (rendered by FiraCode — no emoji font needed)
CODE=$(echo "$JSON" | jq -r '.current_condition[0].weatherCode')
case $CODE in
    113)                         ICON="󰖙" ;;  # Sunny / Clear
    116)                         ICON="󰖕" ;;  # Partly cloudy
    119|122)                     ICON="󰖐" ;;  # Cloudy / Overcast
    143|248|260)                 ICON="󰖑" ;;  # Mist / Fog
    176|263|266|293|296|299|\
    302|305|308|353|356|359)     ICON="󰖗" ;;  # Rain
    179|227|230|323|326|329|\
    332|335|338|368|371|374)     ICON="󰖘" ;;  # Snow
    182|185|311|314|317|320|\
    350|377)                     ICON="󰖘" ;;  # Sleet
    200|386|389|392|395)         ICON="󰖛" ;;  # Thunderstorm
    *)                           ICON="󰖩" ;;  # Unknown
esac

TEMP=$(echo "$JSON"  | jq -r '.current_condition[0].temp_F')
DESC=$(echo "$JSON"  | jq -r '.current_condition[0].weatherDesc[0].value')
FEELS=$(echo "$JSON" | jq -r '.current_condition[0].FeelsLikeF')
HUMID=$(echo "$JSON" | jq -r '.current_condition[0].humidity')
WIND=$(echo "$JSON"  | jq -r '.current_condition[0].windspeedMiles')
UV=$(echo "$JSON"    | jq -r '.current_condition[0].uvIndex')

DAY0=$(echo "$JSON" | jq -r '.weather[0] | "\(.date)  \(.hourly[4].weatherDesc[0].value)  High \(.maxtempF)°F / Low \(.mintempF)°F"')
DAY1=$(echo "$JSON" | jq -r '.weather[1] | "\(.date)  \(.hourly[4].weatherDesc[0].value)  High \(.maxtempF)°F / Low \(.mintempF)°F"')
DAY2=$(echo "$JSON" | jq -r '.weather[2] | "\(.date)  \(.hourly[4].weatherDesc[0].value)  High \(.maxtempF)°F / Low \(.mintempF)°F"')

TEXT="${ICON} ${TEMP}°F"

TOOLTIP="${DESC}  ${TEMP}°F  (Feels like ${FEELS}°F)
Humidity: ${HUMID}%  |  Wind: ${WIND} mph  |  UV: ${UV}

3-Day Forecast
${DAY0}
${DAY1}
${DAY2}"

jq -cn --arg text "$TEXT" --arg tooltip "$TOOLTIP" \
    '{"text": $text, "tooltip": $tooltip, "class": ""}'
