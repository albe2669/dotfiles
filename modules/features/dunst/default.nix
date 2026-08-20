_: {
  flake.modules.homeManager.dunst = {config, ...}: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = [
    ];

    xdg.configFile.dunst = {
      source = helpers.mkDotfilesSymlink config "features/dunst/config";
    };
  };
}
