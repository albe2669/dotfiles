{config, ...}: {
  xdg.configFile.i3 = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
