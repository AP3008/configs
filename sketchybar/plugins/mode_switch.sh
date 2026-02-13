#!/bin/bash
source "$CONFIG_DIR/colors.sh"

MODE_FILE="/tmp/sketchybar_mode"
CURRENT_MODE=$(cat "$MODE_FILE" 2>/dev/null || echo "work")

ACTION="${1:-init}"

# If this is a toggle action (from click), switch the mode
if [ "$ACTION" = "toggle" ]; then
  if [ "$CURRENT_MODE" = "work" ]; then
    echo "code" > "$MODE_FILE"
    CURRENT_MODE="code"
  else
    echo "work" > "$MODE_FILE"
    CURRENT_MODE="work"
  fi
fi

# Update the mode switch button appearance
if [ "$CURRENT_MODE" = "work" ]; then
  sketchybar --set mode_switch icon="󰁯" label="WORK"
else
  sketchybar --set mode_switch icon="" label="CODE"
fi

# Define mode-specific items
WORK_ITEMS="pomodoro meeting_indicator"
CODE_ITEMS="lang_runtime git_info docker_status mem_usage"

# Toggle visibility based on current mode
if [ "$CURRENT_MODE" = "work" ]; then
  for item in $WORK_ITEMS; do
    sketchybar --set $item drawing=on 2>/dev/null
  done
  for item in $CODE_ITEMS; do
    sketchybar --set $item drawing=off 2>/dev/null
  done
else
  for item in $WORK_ITEMS; do
    sketchybar --set $item drawing=off 2>/dev/null
  done
  for item in $CODE_ITEMS; do
    sketchybar --set $item drawing=on 2>/dev/null
  done
fi
