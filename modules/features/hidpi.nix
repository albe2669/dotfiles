{config, ...}: {
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
      "GDK_SCALE,2"
    ];

    programs.kitty.font.size = lib.mkIf config.opts.variables.isHidpi (lib.mkForce 13);
  };

  flake.modules.combined.hidpi = {...}: {
    imports = [config.flake.modules.nixos.hidpi];
    hm.imports = [config.flake.modules.homeManager.hidpi];
  };
}
