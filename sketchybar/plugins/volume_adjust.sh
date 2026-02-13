#!/bin/bash

# Get current volume
CURRENT=$(osascript -e 'output volume of (get volume settings)')

if [ "$1" = "up" ]; then
  NEW=$((CURRENT + 10))
  if [ "$NEW" -gt 100 ]; then NEW=100; fi
elif [ "$1" = "down" ]; then
  NEW=$((CURRENT - 10))
  if [ "$NEW" -lt 0 ]; then NEW=0; fi
else
  exit 0
fi

osascript -e "set volume output volume $NEW"
