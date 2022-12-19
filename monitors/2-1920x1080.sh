#!/bin/bash

# If all displays should be in use, insert this instead of --off
# --primary --mode 3840x2400 --pos 1924x2160 --rotate normal \
xrandr --dpi 192 \
  --output eDP-1 --off \
  --output DP-2-1 --primary --mode 1920x1080 --scale 2x2 --pos 0x0 --rotate normal \
  --output DP-3 --mode 1920x1080 --scale 2x2 --pos 3840x0 --rotate normal

i3-msg "workspace 1, move workspace to output DP-2-1"
i3-msg "workspace 2, move workspace to output DP-3"
