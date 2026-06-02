{
  config,
  lib,
  ...
}: let
  opts = config.opts;
in {
  config = lib.mkIf opts.variables.isHidpi {
    wayland.windowManager.hyprland = {
      extraConfig = ''
        monitor = , highres, auto, 2

        xwayland {
          force_zero_scaling = true
        }

        env = GDK_SCALE=${toString opts.variables.screen.scaleFactor}
      '';
    };

    xresources.properties = {
      "Xft.dpi" = opts.variables.screen.dpi;
    };

    stylix.fonts.sizes.terminal = lib.mkForce 11;

    # home.file.".Xresources" = {
    #   text = ''
    #     Xft.dpi: ${toString opts.variables.screen.dpi}
    #   '';
    # };
  };
}
