{
  pkgs,
  config,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    rofi
  ];

  xdg.configFile.rofi = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/rofi/config");
  };
}
