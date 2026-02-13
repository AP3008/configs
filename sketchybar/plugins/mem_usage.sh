#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# Get memory info from vm_stat
STATS=$(vm_stat 2>/dev/null)
PAGE_SIZE=$(sysctl -n hw.pagesize 2>/dev/null || echo 16384)

# Parse page counts
PAGES_FREE=$(echo "$STATS" | awk '/Pages free/{gsub(/\./,""); print $3}')
PAGES_ACTIVE=$(echo "$STATS" | awk '/Pages active/{gsub(/\./,""); print $3}')
PAGES_INACTIVE=$(echo "$STATS" | awk '/Pages inactive/{gsub(/\./,""); print $3}')
PAGES_SPECULATIVE=$(echo "$STATS" | awk '/Pages speculative/{gsub(/\./,""); print $3}')
PAGES_WIRED=$(echo "$STATS" | awk '/Pages wired/{gsub(/\./,""); print $4}')
PAGES_COMPRESSED=$(echo "$STATS" | awk '/Pages occupied by compressor/{gsub(/\./,""); print $5}')

# Total physical memory in pages
TOTAL_MEM=$(sysctl -n hw.memsize 2>/dev/null)
TOTAL_PAGES=$((TOTAL_MEM / PAGE_SIZE))

# Used = active + wired + compressed
USED_PAGES=$(( ${PAGES_ACTIVE:-0} + ${PAGES_WIRED:-0} + ${PAGES_COMPRESSED:-0} ))

if [ "$TOTAL_PAGES" -gt 0 ]; then
  PERCENT=$((USED_PAGES * 100 / TOTAL_PAGES))
else
  PERCENT=0
fi

sketchybar --set $NAME label="${PERCENT}%"
