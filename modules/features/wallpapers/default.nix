_: {
  flake.modules.homeManager.wallpapers = {config, ...}: let
    helpers = import ../../../lib/helpers.nix;
  in {
    xdg.configFile.wallpapers = {
      source = helpers.mkDotfilesSymlink config "features/wallpapers/images";
    };
  };
}
