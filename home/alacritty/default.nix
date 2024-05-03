{
  pkgs,
  config,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    alacritty
  ];

  # TODO: Coloring
  xdg.configFile.alacritty = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/alacritty/config");
  };
}
