{...}:
{
  wayland.windowManager.hyprland = {
    extraConfig = ''
      monitor = , highres, auto, 2

      xwayland {
        force_zero_scaling = true
      }

      env = GDK_SCALE=2
      env = GDK_DPI_SCALE=0.5
    '';
  };
}
