#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"

STATE=""
TITLE=""
ARTIST=""

# Try to get info from the media_change event first
if [ -n "$INFO" ] && [ "$INFO" != "" ]; then
  STATE="$(echo "$INFO" | jq -r '.state // empty' 2>/dev/null)"
  TITLE="$(echo "$INFO" | jq -r '.title // empty' 2>/dev/null)"
  ARTIST="$(echo "$INFO" | jq -r '.artist // empty' 2>/dev/null)"
fi

# If no event data, poll Spotify directly via AppleScript
if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
  if pgrep -x "Spotify" >/dev/null 2>&1; then
    SPOTIFY_INFO=$(osascript -e '
      tell application "Spotify"
        if it is running then
          set trackName to name of current track
          set trackArtist to artist of current track
          set playerState to player state as string
          return playerState & "|" & trackName & "|" & trackArtist
        end if
      end tell' 2>/dev/null)

    if [ -n "$SPOTIFY_INFO" ]; then
      STATE=$(echo "$SPOTIFY_INFO" | cut -d'|' -f1)
      TITLE=$(echo "$SPOTIFY_INFO" | cut -d'|' -f2)
      ARTIST=$(echo "$SPOTIFY_INFO" | cut -d'|' -f3)
    fi
  fi
fi

# If still nothing, try Apple Music
if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
  if pgrep -x "Music" >/dev/null 2>&1; then
    MUSIC_INFO=$(osascript -e '
      tell application "Music"
        if it is running and player state is not stopped then
          set trackName to name of current track
          set trackArtist to artist of current track
          set playerState to player state as string
          return playerState & "|" & trackName & "|" & trackArtist
        end if
      end tell' 2>/dev/null)

    if [ -n "$MUSIC_INFO" ]; then
      STATE=$(echo "$MUSIC_INFO" | cut -d'|' -f1)
      TITLE=$(echo "$MUSIC_INFO" | cut -d'|' -f2)
      ARTIST=$(echo "$MUSIC_INFO" | cut -d'|' -f3)
    fi
  fi
fi

# Update the bar item
if [ -n "$TITLE" ] && [ "$TITLE" != "null" ] && [ "$TITLE" != "" ]; then
  MEDIA="$TITLE - $ARTIST"
  if [ "$STATE" = "playing" ]; then
    sketchybar --set $NAME label="$MEDIA" drawing=on icon="󰐊"
  else
    sketchybar --set $NAME label="$MEDIA" drawing=on icon="󰏤"
  fi
else
  sketchybar --set $NAME drawing=off
fi
