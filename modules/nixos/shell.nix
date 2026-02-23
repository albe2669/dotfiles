{self, pkgs, ...}: {
  imports = [
    self.sharedModules.shell
  ];

  users.defaultUserShell = pkgs.fish;
}
