{ config, ... }: {
  flake.modules.darwin.system-settings = { lib, ... }: {
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
  };

  flake.modules.combined.system-settings = { ... }: {
    imports = [ config.flake.modules.darwin.system-settings ];
  };
}
