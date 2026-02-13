#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# Get the front app name from the event or query it
FRONT_APP="$INFO"
if [ -z "$FRONT_APP" ]; then
  FRONT_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
fi

ICON=""
LABEL=""

# Get the project directory based on front app
get_project_dir() {
  local app="$1"

  case "$app" in
    "Cursor"|"Code"|"Visual Studio Code")
      # Get window title which usually contains the project folder
      local title=$(osascript -e "tell application \"System Events\" to get title of first window of (first application process whose name is \"$app\")" 2>/dev/null)
      # Window title format is usually "filename — ProjectFolder" or "ProjectFolder"
      local folder=$(echo "$title" | sed 's/ — /\n/' | tail -1 | sed 's/ \[.*$//')
      # Check common project locations
      for base in "$HOME/Desktop/Programming Projects" "$HOME/Documents" "$HOME/Projects" "$HOME"; do
        if [ -d "$base/$folder" ]; then
          echo "$base/$folder"
          return
        fi
      done
      ;;
    "Terminal"|"iTerm2"|"Alacritty"|"kitty"|"WezTerm"|"Ghostty")
      local pid=$(pgrep -x "$app" 2>/dev/null | head -1)
      if [ -n "$pid" ]; then
        lsof -p "$pid" 2>/dev/null | awk '/cwd/{print $NF}' | head -1
        return
      fi
      ;;
  esac
  echo ""
}

PROJECT_DIR=$(get_project_dir "$FRONT_APP")

# If we couldn't detect, try home directory
if [ -z "$PROJECT_DIR" ] || [ ! -d "$PROJECT_DIR" ]; then
  PROJECT_DIR="$HOME"
fi

# Detect language by checking for project files
for d in "$PROJECT_DIR" "$(dirname "$PROJECT_DIR" 2>/dev/null)"; do
  [ -z "$d" ] || [ ! -d "$d" ] && continue
  if [ -f "$d/package.json" ]; then
    ICON=""; LABEL="Node"; break
  elif [ -f "$d/pyproject.toml" ] || [ -f "$d/requirements.txt" ] || [ -f "$d/setup.py" ]; then
    ICON=""; LABEL="Python"; break
  elif [ -f "$d/go.mod" ]; then
    ICON=""; LABEL="Go"; break
  elif [ -f "$d/Cargo.toml" ]; then
    ICON=""; LABEL="Rust"; break
  elif [ -f "$d/Gemfile" ]; then
    ICON=""; LABEL="Ruby"; break
  elif [ -f "$d/build.gradle" ] || [ -f "$d/pom.xml" ]; then
    ICON=""; LABEL="Java"; break
  elif [ -f "$d/Package.swift" ]; then
    ICON=""; LABEL="Swift"; break
  fi
done

if [ -n "$LABEL" ]; then
  sketchybar --set $NAME icon="$ICON" label="$LABEL"
else
  sketchybar --set $NAME icon="" label=""
fi
