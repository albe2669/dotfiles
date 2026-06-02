{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    lazydocker
  ];

  xdg.configFile.lazydocker = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/lazydocker/config");
  };
}
