{
  category = "System software";
  name = "hidpi";

  nixos = {
    config,
    lib,
    ...
  }: {
    services.xserver.dpi = lib.mkIf config.opts.variables.isHidpi 180;
  };

  homeManager = {
    config,
    lib,
    ...
  }: {
    wayland.windowManager.hyprland.settings.env = lib.mkIf config.opts.variables.isHidpi [
      {_args = ["GDK_SCALE" "2"];}
    ];

    programs.kitty.font.size = lib.mkIf config.opts.variables.isHidpi (lib.mkForce 13);
  };
}
