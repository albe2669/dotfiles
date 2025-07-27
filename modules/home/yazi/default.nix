{
  pkgs-unstable,
  config,
  ...
}: {
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
      config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}"
      + (builtins.toPath "/modules/home/yazi/config");
  };
}
