-- Tag-assigning rules must precede the rules that match on those tags.

hl.window_rule({
  name = "jetbrains-splash-tag",
  match = {
    class = "^(jetbrains-.*)$",
    title = "^(splash)$",
    float = true,
  },
  tag = "+jetbrains-splash",
})

hl.window_rule({
  name = "jetbrains-splash",
  match = { tag = "jetbrains-splash" },
  center = true,
  no_focus = true,
  border_size = 0,
})

hl.window_rule({
  name = "jetbrains-tag",
  match = {
    class = "^(jetbrains-.*)",
    title = "^()$",
    float = true,
  },
  tag = "+jetbrains",
})

hl.window_rule({
  name = "jetbrains",
  match = { tag = "jetbrains" },
  center = true,
  stay_focused = true,
  border_size = 0,
})

hl.window_rule({
  name = "jetbrains-size",
  match = {
    class = "^(jetbrains-.*)",
    title = "^()$",
    float = true,
  },
  -- Was `size >50% >50%`; `>` and `%` are not expressible in the
  -- expression parser, min_size is the closest equivalent.
  min_size = "monitor_w*0.5 monitor_h*0.5",
})

hl.window_rule({
  name = "jetbrains-win-no-initial-focus",
  match = {
    class = "^(jetbrains-.*)$",
    title = "^(win.*)$",
    float = true,
  },
  no_initial_focus = true,
})

hl.window_rule({
  name = "jetbrains-no-follow-mouse",
  match = { class = "^(jetbrains-.*)$" },
  no_follow_mouse = true,
})

hl.window_rule({
  name = "unity-tooltip",
  match = {
    class = "^(Unity)$",
    title = "^(UnityTooltipWindow)$",
  },
  no_initial_focus = true,
})

hl.window_rule({
  name = "ueberzug",
  match = { class = "^(ueberzug.*)$" },
  float = true,
  no_initial_focus = true,
  no_anim = true,
  no_shadow = true,
  no_focus = true,
  border_size = 0,
})
