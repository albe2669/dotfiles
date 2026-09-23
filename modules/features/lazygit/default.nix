{
  category = "Tools";
  name = "lazygit";

  homeManager = {
    pkgs,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = with pkgs; [
      lazygit
    ];

    xdg.configFile.lazygit = {
      source = helpers.mkDotfilesSymlink config "features/lazygit/config";
    };
  };
}
