{
  config,
  pkgs-unstable,
  ...
}:
with config.opts; {
  stylix.targets.rio = {
    enable = true;
    colors.enable = true;
    fonts.enable = false;
    opacity.enable = false;
  };

  programs.rio = {
    enable = true;

    package = pkgs-unstable.rio;

    settings = {
      confirm-before-quit = false;

      developer = {
        log-level = "info";
        enable-log-file = true;
      };
      fonts = {
        size = 14;
        family = theme.font.family;

        regular = {
          family = theme.font.family;
          style = "Normal";
          width = "Normal";
          weight = 400;
        };

        bold = {
          family = theme.font.family;
          style = "Normal";
          width = "Normal";
          weight = 800;
        };

        italic = {
          family = theme.font.family;
          style = "Italic";
          width = "Normal";
          weight = 400;
        };

        bold-italic = {
          family = theme.font.family;
          style = "Italic";
          width = "Normal";
          weight = 800;
        };
      };

      cursor = {
        blinking-interval = 750;
        blinking = true;
        shape = "block";
      };

      scroll = {
        # Rio uses "as-needed" history by default, no explicit history limit
        # Alacritty had history = 1000
        multiplier = 3.0;
        divider = 1.0;
      };

      window = {
        opacity = 0.85;
        decorations = "enabled";
        blur = true;
        # Note: Rio does not support window padding like Alacritty
        # Alacritty had padding x=7, y=7
      };

      # colors = let
      #   fg = "#D3C6AA";
      #   bg_dim = "1E2326";
      #   bg0 = "#272E33";
      #   bg_visual = "#4C3743";
      #
      #   black = "#374247";
      #   blue = "#7FBBB3";
      #   cyan = "#83C092";
      #   green = "#A7C080";
      #   magenta = "#D699B6";
      #   red = "#E67E80";
      #   tabs = "#4F5B58";
      #   white = "#9DA9A0";
      #   yellow = "#DBBC7F";
      # in {
      #   background = bg_dim;
      #   foreground = fg;
      #
      #   # Selection
      #   selection-background = bg_visual;
      #   selection-foreground = fg;
      #
      #   # Navigation
      #   # tabs-active = "";
      #   # tabs-active-foreground = "";
      #   # tabs-active-highlight = "";
      #   # bar = "";
      #   # split = "";
      #   cursor = fg; # Color of the cursor
      #   # vi-cursor = bg0;
      #
      #   # Search
      #   search-match-background = bg0;
      #   search-match-foreground = green;
      #   search-focused-match-background = bg0;
      #   search-focused-match-foreground = red;
      #
      #   # Regular colors
      #   black = black;
      #   blue = blue;
      #   cyan = cyan;
      #   green =  green;
      #   magenta = magenta;
      #   red = red;
      #   tabs = tabs;
      #   white = white;
      #   yellow = yellow;
      #
      #   # Dim colors
      #   # dim-black = "";
      #   # dim-blue = "";
      #   # dim-cyan = "";
      #   # dim-foreground = "";
      #   # dim-green = "";
      #   # dim-magenta = "";
      #   # dim-red = "";
      #   # dim-white = "#829181";
      #   # dim-yellow = "";
      #
      #   # Light colors
      #   light-black = "#414b50";
      #   light-blue = "#3A94C5";
      #   light-cyan = "#35A77C";
      #   light-foreground = "#5C6A72";
      #   light-green = "#8DA101";
      #   light-magenta = "#DF69BA";
      #   light-red = "#F85552";
      #   light-white = "#FFFBEF";
      #   light-yellow = "#F57D26";
      # };
    };
  };
}
