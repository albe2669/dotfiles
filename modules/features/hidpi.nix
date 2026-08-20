_: {
  flake.modules.nixos.hidpi = {
    config,
    lib,
    ...
  }: {
    services.xserver.dpi = lib.mkIf config.opts.variables.isHidpi 180;
  };

  flake.modules.homeManager.hidpi = {
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
