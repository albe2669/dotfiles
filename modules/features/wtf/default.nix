_: {
  flake.modules.homeManager.wtf = {
    pkgs-unstable,
    pkgs,
    config,
    lib,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = with pkgs-unstable; [
      wtfutil
    ];

    programs.fish.shellInit = ''
      set -x WTF_GITHUB_TOKEN (${lib.getExe pkgs.gh} auth token)
    '';

    xdg.configFile.wtf = {
      source = helpers.mkDotfilesSymlink config "features/wtf/config";
    };
  };
}
