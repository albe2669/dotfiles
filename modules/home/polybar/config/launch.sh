#!/usr/bin/env bash
# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar.log

polybar --config=~/.config/polybar/config.ini main 2>&1 | tee -a /tmp/polybar_main.log &

echo "Bars launched..." | tee -a /tmp/polybar.log

