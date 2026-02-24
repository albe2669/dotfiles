{
  self,
  lib,
  ...
}: {
  imports = [
    self.sharedModules.docker
  ];

  homebrew.casks = [
    "docker"
  ];
}
