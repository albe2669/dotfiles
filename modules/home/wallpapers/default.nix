{config, ...}: {
  xdg.configFile.wallpapers = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/wallpapers/images");
  };
}
