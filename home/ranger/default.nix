{

  pkgs,
  config,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    ranger
    trash-cli
  ];

  xdg.configFile.ranger = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/ranger/config");
  };
}
