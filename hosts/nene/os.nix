{
  self,
  config,
  ...
}: {
  imports = [
    self.darwinModules.core
    self.darwinModules.shell
  ];

  networking.hostName = config.opts.info.name;
}
