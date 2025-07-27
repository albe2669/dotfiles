{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    killall
    polybar
  ];

  xdg.configFile.polybar = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/polybar/config");
  };
}
