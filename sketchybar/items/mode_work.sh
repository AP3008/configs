#!/bin/bash

MODE=$(cat /tmp/sketchybar_mode 2>/dev/null || echo "work")
if [ "$MODE" = "work" ]; then
  DRAWING="on"
else
  DRAWING="off"
fi

# Pomodoro Timer
sketchybar --add item pomodoro right \
           --set pomodoro \
                 icon="󰔟" \
                 label="25:00" \
                 icon.color=$ACCENT_COLOR \
                 drawing=$DRAWING \
                 update_freq=0 \
                 script="$PLUGIN_DIR/pomodoro.sh" \
                 click_script="sketchybar --set pomodoro popup.drawing=toggle" \
                 popup.background.color=$ITEM_BG_COLOR \
                 popup.background.corner_radius=5 \
                 popup.background.border_width=0

# Popup menu items
sketchybar --add item pomodoro.start popup.pomodoro \
           --set pomodoro.start \
                 icon="󰐊" \
                 label="Start" \
                 icon.color=$ACCENT_COLOR \
                 icon.padding_left=8 \
                 label.padding_right=8 \
                 click_script="$PLUGIN_DIR/pomodoro.sh start"

sketchybar --add item pomodoro.pause popup.pomodoro \
           --set pomodoro.pause \
                 icon="󰏤" \
                 label="Pause" \
                 icon.color=0xfff9e2af \
                 icon.padding_left=8 \
                 label.padding_right=8 \
                 click_script="$PLUGIN_DIR/pomodoro.sh pause"

sketchybar --add item pomodoro.reset popup.pomodoro \
           --set pomodoro.reset \
                 icon="󰜉" \
                 label="Reset" \
                 icon.color=0xfff38ba8 \
                 icon.padding_left=8 \
                 label.padding_right=8 \
                 click_script="$PLUGIN_DIR/pomodoro.sh reset"

# Meeting Indicator (camera/mic in use)
sketchybar --add item meeting_indicator right \
           --set meeting_indicator \
                 icon="󰕧" \
                 label.drawing=off \
                 icon.color=0x55ffffff \
                 drawing=$DRAWING \
                 update_freq=10 \
                 script="$PLUGIN_DIR/meeting.sh"
