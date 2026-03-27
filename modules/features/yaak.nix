{ config, ... }: {
  flake.modules.homeManager.yaak = {pkgs, ...}: {
    home.packages = with pkgs; [
      yaak
    ];
  };

  flake.modules.combined.yaak = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.yaak ];
  };
}
