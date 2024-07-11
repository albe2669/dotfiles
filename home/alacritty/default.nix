{
  pkgs-unstable,
  theme,
  ...
}: {
  programs.alacritty = {
    enable = true;

    # https://nix-community.github.io/home-manager/index.xhtml#_how_do_i_change_the_package_used_by_a_module
    package = pkgs-unstable.alacritty;

    settings = {
      font = {
        size = 8;

        normal = {
          family = theme.font.family;
          style = theme.font.regularStyle;
        };

        bold = {
          family = theme.font.family;
          style = theme.font.boldStyle;
        };

        italic = {
          family = theme.font.family;
          style = theme.font.italicStyle;
        };

        bold_italic = {
          family = theme.font.family;
          style = theme.font.boldItalicStyle;
        };
      };

      cursor = {
        blink_interval = 750;
        style = {
          blinking = "Always";
          shape = "Block";
        };
      };

      scrolling = {
        history = 1000;
        multiplier = 3;
      };

      window = {
        dynamic_padding = false;
        opacity = 0.85;

        padding = {
          x = 7;
          y = 7;
        };
      };

      colors.primary = {
        background = theme.colors.bg_dim;
        foreground = theme.colors.fg;
      };
    };
  };
}
