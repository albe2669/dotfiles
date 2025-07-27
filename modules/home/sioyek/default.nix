{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    sioyek
  ];

  xdg.configFile.sioyek = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/sioyek/config");
  };
}
