let
  common = _: {
    services.tailscale = {
      enable = true;
    };
  };
in {
  category = "System software";
  name = "tailscale";

  nixos = common;
  darwin = common;

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      tailscale
    ];
  };
}
