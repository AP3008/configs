#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# Get the front app name
FRONT_APP="$INFO"
if [ -z "$FRONT_APP" ]; then
  FRONT_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
fi

# Get project directory
PROJECT_DIR=""

case "$FRONT_APP" in
  "Cursor"|"Code"|"Visual Studio Code")
    title=$(osascript -e "tell application \"System Events\" to get title of first window of (first application process whose name is \"$FRONT_APP\")" 2>/dev/null)
    folder=$(echo "$title" | sed 's/ — /\n/' | tail -1 | sed 's/ \[.*$//')
    for base in "$HOME/Desktop/Programming Projects" "$HOME/Documents" "$HOME/Projects" "$HOME"; do
      if [ -d "$base/$folder" ]; then
        PROJECT_DIR="$base/$folder"
        break
      fi
    done
    ;;
  "Terminal"|"iTerm2"|"Alacritty"|"kitty"|"WezTerm"|"Ghostty")
    pid=$(pgrep -x "$FRONT_APP" 2>/dev/null | head -1)
    if [ -n "$pid" ]; then
      PROJECT_DIR=$(lsof -p "$pid" 2>/dev/null | awk '/cwd/{print $NF}' | head -1)
    fi
    ;;
esac

if [ -z "$PROJECT_DIR" ]; then
  PROJECT_DIR="$HOME"
fi

# Check if it's a git repo
BRANCH=$(git -C "$PROJECT_DIR" branch --show-current 2>/dev/null)

if [ -n "$BRANCH" ]; then
  # Check for uncommitted changes
  DIRTY=$(git -C "$PROJECT_DIR" status --porcelain 2>/dev/null | head -1)
  if [ -n "$DIRTY" ]; then
    LABEL="$BRANCH *"
  else
    LABEL="$BRANCH"
  fi
  sketchybar --set $NAME icon="" label="$LABEL" icon.color=$ACCENT_COLOR
else
  sketchybar --set $NAME icon="" label="" icon.color=0x55ffffff
fi
