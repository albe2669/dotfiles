{
  config,
  variables,
  ...
}: {
  # Must be installed manually
  xdg.configFile.kitty = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/kitty/config");
  };
}
