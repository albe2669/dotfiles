local mod = "SUPER"
local terminal = "kitty"
-- Not bound to a key, kept for reference (was the `$fileManager` variable).
local fileManager = "nautilus" ---@diagnostic disable-line: unused-local

hl.bind(mod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + SHIFT + q", hl.dsp.window.close())
hl.bind(mod .. " + f", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + escape", hl.dsp.exec_cmd("hyprlock"))

-- No native Lua API for `hyprctl reload`.
hl.bind(mod .. " + SHIFT + r", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + SHIFT + e", hl.dsp.exit())

-- No native Lua API for switchxkblayout.
hl.bind(mod .. " + CONTROL + u", hl.dsp.exec_cmd("hyprctl switchxkblayout current 0"))
hl.bind(mod .. " + CONTROL + d", hl.dsp.exec_cmd("hyprctl switchxkblayout current 1"))

hl.bind("print", hl.dsp.exec_cmd([[wayfreeze & PID=$!; sleep .1; grim -g "$(slurp)" - | wl-copy; kill $PID]]))
hl.bind("SHIFT + print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | satty -f -]]))

hl.bind(mod .. " + d", hl.dsp.exec_cmd("nc -U /run/user/1000/walker/walker.sock"))
hl.bind(mod .. " + SHIFT + d", hl.dsp.exec_cmd("wlogout"))

hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))

hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))

hl.bind(mod .. " + CONTROL + j", hl.dsp.window.move({ monitor = "d" }))
hl.bind(mod .. " + CONTROL + k", hl.dsp.window.move({ monitor = "u" }))
hl.bind(mod .. " + CONTROL + l", hl.dsp.window.move({ monitor = "r" }))
hl.bind(mod .. " + CONTROL + h", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mod .. " + CONTROL + down", hl.dsp.window.move({ monitor = "d" }))
hl.bind(mod .. " + CONTROL + up", hl.dsp.window.move({ monitor = "u" }))
hl.bind(mod .. " + CONTROL + right", hl.dsp.window.move({ monitor = "r" }))
hl.bind(mod .. " + CONTROL + left", hl.dsp.window.move({ monitor = "l" }))

-- code:10 .. code:18 are the physical 1..9 keys, layout independent.
for i = 0, 8 do
  hl.bind(mod .. " + code:1" .. i, hl.dsp.focus({ workspace = i + 1 }))
  hl.bind(mod .. " + SHIFT + code:1" .. i, hl.dsp.window.move({ workspace = i + 1 }))
end

-- Previously `binde` (repeat while held).
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { repeating = true })

-- Previously `bindm` (mouse drag).
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize())

-- Previously `bindl` (works while locked).
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
