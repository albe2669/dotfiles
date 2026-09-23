{
  category = "System software";
  name = "dunst";

  homeManager = {config, ...}: let
    helpers = import ../../../lib/helpers.nix;
  in {
    xdg.configFile.dunst = {
      source = helpers.mkDotfilesSymlink config "features/dunst/config";
    };
  };
}
