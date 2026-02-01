{...}: {
  stylix.targets.kitty = {
    enable = true;
    colors.enable = true;
    fonts = {
      enable = true;
    };
    opacity.enable = true;
  };

  programs.kitty = {
    enable = true;

    settings = {
      scrollback_lines = 5000;
      cursor_shape = "block";
    };
  };
}
