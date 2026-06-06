#!/usr/bin/env bash
# brightness.sh raise|lower — change brightness and show dunst progress bar

case $1 in
    raise) brightnessctl set 10%+ >/dev/null ;;
    lower) brightnessctl set 10%- >/dev/null ;;
esac

MAX=$(brightnessctl max)
CUR=$(brightnessctl get)
PERCENT=$(( CUR * 100 / MAX ))

notify-send -a "brightness" \
    -h int:value:"$PERCENT" \
    -h string:x-dunst-stack-tag:brightness \
    -t 2000 \
    "󰃞  Brightness" "${PERCENT}%"
