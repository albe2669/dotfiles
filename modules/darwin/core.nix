{
  self,
  lib,
  ...
}: {
  imports = [
    self.darwinModules.nix
    self.darwinModules.system-packages
    self.darwinModules.user
    self.darwinModules.homebrew
  ];

  system.defaults = {
    dock = {
      autohide = lib.mkDefault true;
      mru-spaces = lib.mkDefault false;
      minimize-to-application = lib.mkDefault true;
    };

    finder = {
      AppleShowAllExtensions = lib.mkDefault true;
      QuitMenuItem = lib.mkDefault true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = lib.mkDefault true;
      InitialKeyRepeat = lib.mkDefault 14;
      KeyRepeat = lib.mkDefault 1;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
