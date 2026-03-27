{ config, ... }: {
  flake.modules.homeManager.guiutils = {pkgs, ...}: {
    home.packages = with pkgs; [
      # Networks
      networkmanagerapplet
    ];
  };

  flake.modules.combined.guiutils = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.guiutils ];
  };
}
