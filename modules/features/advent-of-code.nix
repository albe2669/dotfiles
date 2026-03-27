{ config, ... }: {
  flake.modules.homeManager.advent-of-code = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      # gnucobol
    ];
  };

  flake.modules.combined.advent-of-code = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.advent-of-code ];
  };
}
