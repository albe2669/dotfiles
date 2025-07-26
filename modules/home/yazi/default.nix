{
  pkgs-unstable,
  config,
  variables,
  ...
}:
{
  home.packages = with pkgs-unstable; [
    yazi
    exiftool
    mediainfo
    poppler_utils
    ueberzugpp
    xdragon
    wl-clipboard
  ];

  xdg.configFile.yazi = {
    source =
      config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}"
      + (builtins.toPath "/home/yazi/config");
  };
}
