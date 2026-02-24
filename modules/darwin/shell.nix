{self, pkgs, ...}: {
  imports = [
    self.sharedModules.shell
  ];

  environment.variables.SHELL = "${pkgs.fish}/bin/fish";
}
