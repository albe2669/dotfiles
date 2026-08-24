#!/usr/bin/env bash

SPACE=$(aerospace list-workspaces --focused 2>/dev/null | head -1)
[ -z "$SPACE" ] && SPACE="Desktop"
sketchybar --set space label="$SPACE"
