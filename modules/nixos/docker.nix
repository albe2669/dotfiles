{
  self,
  lib,
  ...
}: {
  imports = [
    self.sharedModules.docker
  ];

  virtualisation.docker = {
    enable = lib.mkDefault true;
    enableOnBoot = lib.mkDefault true;
    liveRestore = false;
  };
}
