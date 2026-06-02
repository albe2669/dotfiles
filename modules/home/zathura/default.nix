{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = lib.mkIf pkgs.stdenv.isLinux (with pkgs; [
    zathura
  ]);

  xdg.configFile.zathura = lib.mkIf pkgs.stdenv.isLinux {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/zathura/config");
  };
}
