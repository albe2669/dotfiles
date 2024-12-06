{
  pkgs-unstable,
  config,
  variables,
  ...
}: {
  home.packages = with pkgs-unstable; [
    yazi
    poppler_utils
    ueberzugpp
    xdragon
  ];

  xdg.configFile.yazi = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/yazi/config");
  };
}
