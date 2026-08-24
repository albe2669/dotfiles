{config, ...}: {
  flake.modules.homeManager.sketchybar = {
    pkgs-unstable,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = with pkgs-unstable; [
      sketchybar
    ];

    xdg.configFile.sketchybar = {
      source = helpers.mkDotfilesSymlink config "features/sketchybar/config";
      recursive = true;
    };
  };

  flake.modules.combined.sketchybar = _: {
    hm.imports = [config.flake.modules.homeManager.sketchybar];
  };
}
