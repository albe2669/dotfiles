{
  self,
  config,
  ...
}: {
  imports = [
    self.darwinModules.core
  ];

  networking.hostName = config.opts.info.name;
}
