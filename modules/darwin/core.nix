{self, ...}: {
  imports = [
    self.darwinModules.nix
    self.darwinModules.system-packages
    self.darwinModules.system-settings
    self.darwinModules.user
    self.darwinModules.homebrew
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
}
