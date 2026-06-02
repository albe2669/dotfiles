{
  self,
  lib,
  ...
}: {
  imports = [
    self.sharedModules.docker
  ];

  homebrew.casks = [
    "orbstack"
    "docker-desktop"
  ];
}
