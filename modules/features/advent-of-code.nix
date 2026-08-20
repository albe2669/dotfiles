_: {
  flake.modules.homeManager.advent-of-code = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      # gnucobol
    ];
  };
}
