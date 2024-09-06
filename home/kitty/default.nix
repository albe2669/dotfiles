{
  pkgs,
  config,
  variables,
  ...
}: {
  home.packages = [
    (pkgs.callPackage ../../pkgs/kitty {})
  ];

  # Must be installed manually
  xdg.configFile.kitty = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/kitty/config");
  };
}
