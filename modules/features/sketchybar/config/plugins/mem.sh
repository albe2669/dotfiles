#!/usr/bin/env bash

PAGE_SIZE=4096
ACTIVE=$(vm_stat | awk '/^Pages active/ { gsub("\.","",$3); print $3 }')
WIRED=$(vm_stat | awk '/^Pages wired/ { gsub("\.","",$3); print $3 }')
COMPRESSED=$(vm_stat | awk '/^Pages occupied by compressor/ { gsub("\.","",$6); print $6 }')

USED=$(( (ACTIVE + WIRED + COMPRESSED) * PAGE_SIZE ))
TOTAL=$(sysctl -n hw.memsize 2>/dev/null)

if [ -z "$TOTAL" ] || [ "$TOTAL" -eq 0 ]; then
  PCT=0
else
  PCT=$(( USED * 100 / TOTAL ))
fi

COLOR=$COLOR_GREEN
if [ "$PCT" -ge 80 ] 2>/dev/null; then
  COLOR=$COLOR_RED
elif [ "$PCT" -ge 50 ] 2>/dev/null; then
  COLOR=$COLOR_YELLOW
fi

sketchybar --set mem label="${PCT}%" label.color=$COLOR icon.color=$COLOR
