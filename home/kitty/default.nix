{config, ...}: {
  # Must be installed manually
  xdg.configFile.kitty = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
