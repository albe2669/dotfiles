_: let
  common = _: {
    services.tailscale = {
      enable = true;
    };
  };
in {
  flake.modules.nixos.tailscale = common;
  flake.modules.darwin.tailscale = common;

  flake.modules.homeManager.tailscale = {pkgs, ...}: {
    home.packages = with pkgs; [
      tailscale
    ];
  };
}
