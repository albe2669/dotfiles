{
  self,
  system,
  config,
  ...
}: {
  home.packages = [
    self.packages.${system}.kitty
  ];

  # Must be installed manually
  xdg.configFile.kitty = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/kitty/config");
  };
}
