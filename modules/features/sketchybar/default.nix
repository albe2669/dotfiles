{
  category = "Software";
  name = "sketchybar";

  homeManager = {
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
}
