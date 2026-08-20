_: {
  flake.modules.homeManager.lazydocker = {
    pkgs,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = with pkgs; [
      lazydocker
    ];

    xdg.configFile.lazydocker = {
      source = helpers.mkDotfilesSymlink config "features/lazydocker/config";
    };
  };
}
