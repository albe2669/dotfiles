{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    zathura
  ];

  xdg.configFile.zathura = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/zathura/config");
  };
}
