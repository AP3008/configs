#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# Check if camera is in use (common indicator of a video call)
CAMERA_IN_USE=$(log show --predicate 'subsystem == "com.apple.UVCExtension" AND composedMessage CONTAINS "Post PowerLog"' --last 5s 2>/dev/null | grep -c "PowerLog" 2>/dev/null)

# Simpler fallback: check for common video call processes
if [ "$CAMERA_IN_USE" -gt 0 ] 2>/dev/null; then
  IN_MEETING=true
else
  # Check if common meeting apps are using the camera
  MEETING_APPS=$(lsof 2>/dev/null | grep -i "VDC" | grep -iE "zoom|teams|meet|facetime|webex|slack" | head -1)
  if [ -n "$MEETING_APPS" ]; then
    IN_MEETING=true
  else
    IN_MEETING=false
  fi
fi

if [ "$IN_MEETING" = true ]; then
  sketchybar --set $NAME icon="󰕧" icon.color=0xfff38ba8 label="ON AIR" label.drawing=on
else
  sketchybar --set $NAME icon="󰕧" icon.color=0x55ffffff label.drawing=off
fi
