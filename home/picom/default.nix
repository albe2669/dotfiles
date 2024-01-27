{ nvidiaDrivers ? false, ... }: {
  # I3 currently starts picom for us
  # TODO: Remove this once we have a better way to configure i3
  services.picom = {
    enable = true;

    backend = if nvidiaDrivers then "glx" else "xrender";

    shadow = true;
    shadowOpacity = 0.75;
    shadowExclude = [
      "_GTK_FRAME_EXTENTS@:c"
      "class_g = 'Polybar'"
    ];

    inactiveOpacity = 1;
    activeOpacity = 1;
    opacityRules = [
      "88:class_g = 'discord'"
      "85:class_g = 'Code'"
      "85:class_g = 'nautilus'"
      "85:class_g = 'Zathura'"
    ];

    settings = {
      daemon = true;
      shadow-radius = 15;
      frame-opacity = 0.8;

      blur-method = "dual_kawase";
      blur-strength = 12;
      blur-background = true;

      background = true;
      background-frame = false;
      background-fixed = false;

      background-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
        "class_g = 'Polybar'"
      ];

      corner-radious = 15;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "class_g = 'nautilus'"
        "class_g = 'Polybar'"
      ];

      vsync = true;
    };
  };



  # home.packages = with pkgs; [
  #   picom
  # ];

  # xdg.configFile.picom = {
  #   source = ./config;
  #   recursive = true;
  # };
}
