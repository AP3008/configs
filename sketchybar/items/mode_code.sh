#!/bin/bash

MODE=$(cat /tmp/sketchybar_mode 2>/dev/null || echo "work")
if [ "$MODE" = "code" ]; then
  DRAWING="on"
else
  DRAWING="off"
fi

# Language/Runtime Indicator
sketchybar --add item lang_runtime right \
           --set lang_runtime \
                 icon="" \
                 label="" \
                 icon.font="Iosevka Nerd Font:Bold:16.0" \
                 icon.color=$ACCENT_COLOR \
                 drawing=$DRAWING \
                 script="$PLUGIN_DIR/lang_runtime.sh" \
           --subscribe lang_runtime front_app_switched

# Git Branch & Status
sketchybar --add item git_info right \
           --set git_info \
                 icon="" \
                 label="" \
                 icon.color=$ACCENT_COLOR \
                 drawing=$DRAWING \
                 update_freq=10 \
                 script="$PLUGIN_DIR/git_info.sh" \
           --subscribe git_info front_app_switched

# Docker Container Count
sketchybar --add item docker_status right \
           --set docker_status \
                 icon="" \
                 label="Off" \
                 icon.color=0x55ffffff \
                 drawing=$DRAWING \
                 update_freq=15 \
                 script="$PLUGIN_DIR/docker_status.sh"

# Memory Usage
sketchybar --add item mem_usage right \
           --set mem_usage \
                 icon="󰍛" \
                 label="0%" \
                 icon.color=$ACCENT_COLOR \
                 drawing=$DRAWING \
                 update_freq=5 \
                 script="$PLUGIN_DIR/mem_usage.sh"
