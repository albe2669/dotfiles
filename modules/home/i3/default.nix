{
  config,
  variables,
  ...
}: {
  xdg.configFile.i3 = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/i3/config");
  };
}
