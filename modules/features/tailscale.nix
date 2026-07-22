{config, ...}: {
  flake.modules.nixos.tailscale = _: {
    services.tailscale = {
      enable = true;
    };
  };

  flake.modules.combined.tailscale = {...}: {
    imports = [config.flake.modules.nixos.tailscale];
  };
}
