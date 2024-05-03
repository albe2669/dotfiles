{
  pkgs,
  config,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    polybar
  ];

  xdg.configFile.polybar = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/polybar/config");
  };
}
