_: {
  flake.modules.homeManager.opencode = {
    pkgs-unstable,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = with pkgs-unstable; [
      opencode
    ];

    xdg.configFile.opencode = {
      source = helpers.mkDotfilesSymlink config "features/opencode/config";
    };
  };
}
