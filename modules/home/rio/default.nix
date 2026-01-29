{
  config,
  pkgs-unstable,
  ...
}:
with config.opts; {
  stylix.targets.rio = {
    enable = true;
    colors = {
      enable = true;
      override = {
        background = theme.colors.bg_dim;
      };
    };
    opacity.enable = false;
    fonts.enable = false;
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
    };
  };
}
