{
  config,
  ...
}: {
  xdg.configFile.i3 = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/i3/config");
  };
}
