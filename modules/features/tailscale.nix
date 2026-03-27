{ config, ... }: {
  flake.modules.nixos.tailscale = { ... }: {
    services.tailscale = {
      enable = true;
    };
  };

  flake.modules.combined.tailscale = { ... }: {
    imports = [ config.flake.modules.nixos.tailscale ];
  };
}
