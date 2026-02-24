{
  config,
  lib,
  pkgs,
  ...
}: {
  stylix.targets.kitty = {
    enable = true;
    colors.enable = true;
    fonts.enable = false;
    opacity.enable = true;
  };

  programs.kitty = {
    enable = true;

    font = {
      inherit (config.stylix.fonts.sansSerif) name package;
      size = config.stylix.fonts.sizes.terminal;
    };

    settings =
      {
        scrollback_lines = 5000;
        cursor_shape = "block";
      }
      // lib.optionalAttrs config.opts.variables.isDarwin {
        background_blur = 48;
        shell = "${pkgs.fish}/bin/fish";
      };
  };
}
