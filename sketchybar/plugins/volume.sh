#!/bin/bash
source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case $VOLUME in
    [6-9][0-9]|100) ICON="󰕾" ;;
    [3-5][0-9])     ICON="󰖀" ;;
    [1-9]|[1-2][0-9]) ICON="󰕿" ;;
    *)              ICON="󰖁" ;;
  esac

  sketchybar --set $NAME icon="$ICON" label="$VOLUME%"

  # Build slider bar (10 segments)
  FILLED=$((VOLUME / 10))
  EMPTY=$((10 - FILLED))

  BAR=""
  for ((i=0; i<FILLED; i++)); do BAR+="█"; done
  for ((i=0; i<EMPTY; i++)); do BAR+="░"; done

  sketchybar --set volume.slider label="$BAR"
fi
