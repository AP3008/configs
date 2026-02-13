#!/bin/bash
source "$CONFIG_DIR/colors.sh"

COUNT=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')

if [ $? -ne 0 ] || [ -z "$COUNT" ]; then
  # Docker not running
  sketchybar --set $NAME icon="" label="Off" icon.color=0x55ffffff
elif [ "$COUNT" = "0" ]; then
  sketchybar --set $NAME icon="" label="0" icon.color=0x55ffffff
else
  sketchybar --set $NAME icon="" label="$COUNT" icon.color=$ACCENT_COLOR
fi
