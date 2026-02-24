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
  ];

  networking.hostName = config.opts.info.name;
}
