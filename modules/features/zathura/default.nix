_: {
  flake.modules.homeManager.zathura = {
    pkgs,
    lib,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    home.packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (with pkgs; [
      zathura
    ]);

    xdg.configFile.zathura = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      source = helpers.mkDotfilesSymlink config "features/zathura/config";
    };
  };
}
