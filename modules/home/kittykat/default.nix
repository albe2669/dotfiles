{
  self,
  system,
  config,
  ...
}: {
  home.packages = [
    self.packages.${system}.kittykat
  ];

  # Must be installed manually
  xdg.configFile.kittykat = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/kittykat/config");
  };
}
