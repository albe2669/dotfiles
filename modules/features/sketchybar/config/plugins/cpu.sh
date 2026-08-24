#!/usr/bin/env bash

USAGE=$(top -l 1 -n 0 2>/dev/null | awk '/^CPU usage:/ { for(i=1;i<=NF;i++) if($i ~ /^[0-9.]+%/) { gsub("%","",$i); print $i; exit } }')
[ -z "$USAGE" ] && USAGE=0
USAGE=$(printf "%.0f" "$USAGE" 2>/dev/null || echo "$USAGE")

COLOR=$COLOR_GREEN
if [ "$USAGE" -ge 80 ] 2>/dev/null; then
  COLOR=$COLOR_RED
elif [ "$USAGE" -ge 50 ] 2>/dev/null; then
  COLOR=$COLOR_YELLOW
fi

sketchybar --set cpu label="${USAGE}%" label.color=$COLOR icon.color=$COLOR
