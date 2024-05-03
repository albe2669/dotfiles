{
  pkgs,
  config,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    zathura
  ];

  xdg.configFile.zathura = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/zathura/config");
  };
}
