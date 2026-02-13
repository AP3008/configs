#!/bin/bash

MODE=$(cat /tmp/sketchybar_mode 2>/dev/null || echo "work")

if [ "$MODE" = "work" ]; then
  ICON="󰁯"
  LABEL="WORK"
else
  ICON=""
  LABEL="CODE"
fi

sketchybar --add item mode_switch left \
           --set mode_switch \
                 icon="$ICON" \
                 label="$LABEL" \
                 icon.font="Iosevka Nerd Font:Bold:16.0" \
                 label.font="Iosevka Nerd Font:Bold:12.0" \
                 icon.color=$ACCENT_COLOR \
                 label.color=$ACCENT_COLOR \
                 background.color=$ITEM_BG_COLOR \
                 background.corner_radius=5 \
                 background.height=24 \
                 padding_right=6 \
                 click_script="$PLUGIN_DIR/mode_switch.sh toggle"
