#!/usr/bin/env bash
# volume.sh raise|lower|mute|micmute — change volume and show dunst progress bar

case $1 in
    raise)   wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@  5%+ ;;
    lower)   wpctl set-volume        @DEFAULT_AUDIO_SINK@  5%- ;;
    mute)    wpctl set-mute          @DEFAULT_AUDIO_SINK@  toggle ;;
    micmute) wpctl set-mute          @DEFAULT_AUDIO_SOURCE@ toggle ;;
esac

VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED || true)

if [[ $MUTED -gt 0 ]]; then
    ICON="󰝟"
    LABEL="Muted"
elif [[ $VOLUME -lt 33 ]]; then
    ICON="󰕿"
    LABEL="${VOLUME}%"
elif [[ $VOLUME -lt 66 ]]; then
    ICON="󰖀"
    LABEL="${VOLUME}%"
else
    ICON="󰕾"
    LABEL="${VOLUME}%"
fi

notify-send -a "volume" \
    -h int:value:"$VOLUME" \
    -h string:x-dunst-stack-tag:volume \
    -t 2000 \
    "$ICON  Volume" "$LABEL"
