{
  pkgs,
  config,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    lazydocker
  ];

  xdg.configFile.lazydocker = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/lazydocker/config");
  };
}
