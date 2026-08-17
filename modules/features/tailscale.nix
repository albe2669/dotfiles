{config, ...}: {
  flake.modules.nixos.tailscale = _: {
    services.tailscale = {
      enable = true;
    };
  };

  flake.modules.darwin.tailscale = _: {
    services.tailscale = {
      enable = true;
    };
  };

  flake.modules.homeManager.tailscale = {pkgs, ...}: {
    home.packages = with pkgs; [
      tailscale
    ];
  };

  flake.modules.combined.tailscale = {system, ...}: let
    isDarwin = builtins.match ".*-darwin" system != null;
  in {
    imports = [
      (
        if isDarwin
        then config.flake.modules.darwin.tailscale
        else config.flake.modules.nixos.tailscale
      )
    ];
    hm.imports = [config.flake.modules.homeManager.tailscale];
  };
}
