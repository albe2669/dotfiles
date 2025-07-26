{
  pkgs,
  config,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    dunst
  ];

  xdg.configFile.dunst = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/dunst/config");
  };
}
