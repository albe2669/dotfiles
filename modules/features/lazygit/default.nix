_: {
  flake.modules.homeManager.lazygit = {
    pkgs,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = with pkgs; [
      lazygit
      # commitizen
    ];

    xdg.configFile.lazygit = {
      source = helpers.mkDotfilesSymlink config "features/lazygit/config";
    };
  };
}
