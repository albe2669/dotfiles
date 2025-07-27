{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    dunst
  ];

  xdg.configFile.dunst = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/dunst/config");
  };
}
