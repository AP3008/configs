#!/bin/bash

STATE_FILE="/tmp/sketchybar_pomodoro"
source "$CONFIG_DIR/colors.sh"

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
  echo "state=idle" > "$STATE_FILE"
  echo "start_time=0" >> "$STATE_FILE"
  echo "elapsed_paused=0" >> "$STATE_FILE"
  echo "pause_time=0" >> "$STATE_FILE"
  echo "mode=work" >> "$STATE_FILE"
fi

# Read current state
source "$STATE_FILE"

WORK_DURATION=1500  # 25 minutes
BREAK_DURATION=300  # 5 minutes
NOW=$(date +%s)

ACTION="${1:-tick}"

case "$ACTION" in
  start)
    if [ "$state" = "idle" ] || [ "$state" = "done" ]; then
      # Start fresh
      echo "state=running" > "$STATE_FILE"
      echo "start_time=$NOW" >> "$STATE_FILE"
      echo "elapsed_paused=0" >> "$STATE_FILE"
      echo "pause_time=0" >> "$STATE_FILE"
      echo "mode=work" >> "$STATE_FILE"
      sketchybar --set pomodoro update_freq=1 icon="󰔟" icon.color=$ACCENT_COLOR label.color=$WHITE popup.drawing=off
    elif [ "$state" = "paused" ]; then
      # Resume from pause
      ADDITIONAL_PAUSE=$((NOW - pause_time))
      NEW_ELAPSED=$((elapsed_paused + ADDITIONAL_PAUSE))
      echo "state=running" > "$STATE_FILE"
      echo "start_time=$start_time" >> "$STATE_FILE"
      echo "elapsed_paused=$NEW_ELAPSED" >> "$STATE_FILE"
      echo "pause_time=0" >> "$STATE_FILE"
      echo "mode=$mode" >> "$STATE_FILE"
      sketchybar --set pomodoro update_freq=1 icon.color=$ACCENT_COLOR popup.drawing=off
    fi
    ;;

  pause)
    if [ "$state" = "running" ]; then
      echo "state=paused" > "$STATE_FILE"
      echo "start_time=$start_time" >> "$STATE_FILE"
      echo "elapsed_paused=$elapsed_paused" >> "$STATE_FILE"
      echo "pause_time=$NOW" >> "$STATE_FILE"
      echo "mode=$mode" >> "$STATE_FILE"
      sketchybar --set pomodoro update_freq=0 icon.color=0xfff9e2af popup.drawing=off
    fi
    ;;

  reset)
    echo "state=idle" > "$STATE_FILE"
    echo "start_time=0" >> "$STATE_FILE"
    echo "elapsed_paused=0" >> "$STATE_FILE"
    echo "pause_time=0" >> "$STATE_FILE"
    echo "mode=work" >> "$STATE_FILE"
    sketchybar --set pomodoro label="25:00" update_freq=0 icon="󰔟" icon.color=$ACCENT_COLOR label.color=$WHITE popup.drawing=off
    ;;

  tick|"")
    # Periodic update (timer tick)
    if [ "$state" = "running" ]; then
      ELAPSED=$((NOW - start_time - elapsed_paused))

      if [ "$mode" = "work" ]; then
        REMAINING=$((WORK_DURATION - ELAPSED))
      else
        REMAINING=$((BREAK_DURATION - ELAPSED))
      fi

      if [ "$REMAINING" -le 0 ]; then
        if [ "$mode" = "work" ]; then
          # Work session done, start break
          osascript -e 'display notification "Time for a break!" with title "Pomodoro" sound name "Glass"'
          echo "state=running" > "$STATE_FILE"
          echo "start_time=$NOW" >> "$STATE_FILE"
          echo "elapsed_paused=0" >> "$STATE_FILE"
          echo "pause_time=0" >> "$STATE_FILE"
          echo "mode=break" >> "$STATE_FILE"
          sketchybar --set pomodoro icon="󰒲" icon.color=0xff94e2d5
        else
          # Break done - show DONE indicator
          osascript -e 'display notification "Break is over, back to work!" with title "Pomodoro" sound name "Glass"'
          echo "state=done" > "$STATE_FILE"
          echo "start_time=0" >> "$STATE_FILE"
          echo "elapsed_paused=0" >> "$STATE_FILE"
          echo "pause_time=0" >> "$STATE_FILE"
          echo "mode=work" >> "$STATE_FILE"
          sketchybar --set pomodoro label="DONE!" update_freq=0 icon="󰔟" icon.color=0xffa6e3a1 label.color=0xffa6e3a1
        fi
      else
        MINUTES=$((REMAINING / 60))
        SECONDS=$((REMAINING % 60))
        sketchybar --set pomodoro label="$(printf '%02d:%02d' $MINUTES $SECONDS)"
      fi
    fi
    ;;
esac
