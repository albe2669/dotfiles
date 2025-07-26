{config, lib,...}:
{
    config = lib.mkIf config.variables.isHidpi {
      wayland.windowManager.hyprland = {
        extraConfig = ''
          monitor = , highres, auto, 2

          xwayland {
            force_zero_scaling = true
          }

          env = GDK_SCALE=${config.variables.screen.scaleFactor}
        '';
      };

      home.file.".Xresources" = {
        text = ''
          Xft.dpi: ${toString config.variables.screen.dpi}
        '';
      };
    };
}
