{
  pkgs,
  config,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    sioyek
  ];

  xdg.configFile.sioyek = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/sioyek/config");
  };
}
