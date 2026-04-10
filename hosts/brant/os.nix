{
  self,
  config,
  ...
}: {
  imports = [
    self.darwinModules.core
    self.darwinModules.shell
    self.darwinModules.mac-app-util
    self.darwinModules.docker
    self.darwinModules.aerospace
  ];

  networking.hostName = config.opts.info.name;
}
