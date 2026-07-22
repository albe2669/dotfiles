{self, ...}: {
  imports = [
    self.sharedModules.docker
  ];

  homebrew.casks = [
    "orbstack"
    "docker-desktop"
  ];
}
