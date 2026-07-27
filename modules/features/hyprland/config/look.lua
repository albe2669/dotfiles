local theme = require("theme")

hl.config({
  input = {
    kb_layout = "us,dk",

    accel_profile = "flat",

    touchpad = {
      natural_scroll = true,
    },

    follow_mouse = 1,
    mouse_refocus = false,

    repeat_delay = 210,
    repeat_rate = 67,
  },

  -- Layout/borders/gaps tuned to match the Hyprland Desktop design:
  -- rounded tiles, generous gaps, a green->aqua focus border.
  general = {
    -- layout = "master",

    gaps_in = 5, -- 2x => 10px between tiles, as in the design
    gaps_out = 12, -- 12px margin to the screen edge
    border_size = 2,

    col = {
      active_border = {
        colors = {
          theme.rgba("green"),
          theme.rgba("aqua"),
        },
        angle = 45,
      },
      inactive_border = theme.rgba("bg2"),
    },
  },

  decoration = {
    rounding = 12, -- matches the 12px tiles / "lg" bar rounding in Wayle

    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      new_optimizations = true,
      ignore_opacity = true,
    },

    shadow = {
      enabled = true,
      range = 30,
      render_power = 3,
      color = theme.rgba("bg_dim", "ee"),
    },
  },

  xwayland = {
    force_zero_scaling = true,
  },
})
