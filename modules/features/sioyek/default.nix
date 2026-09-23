{
  category = "Software";
  name = "sioyek";

  homeManager = {
    pkgs,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = with pkgs; [
      sioyek
    ];

    xdg.configFile.sioyek = {
      source = helpers.mkDotfilesSymlink config "features/sioyek/config";
    };
  };
}
