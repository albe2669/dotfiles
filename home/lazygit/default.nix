{
  pkgs,
  config,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    lazygit
  ];

  xdg.configFile.lazygit = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/lazygit/config");
  };
}
