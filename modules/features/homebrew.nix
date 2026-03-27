{ config, ... }: {
  flake.modules.darwin.homebrew = { lib, ... }: {
    homebrew = {
      enable = lib.mkDefault true;
      onActivation = {
        autoUpdate = lib.mkDefault true;
        cleanup = lib.mkDefault "zap";
      };
    };
  };

  flake.modules.combined.homebrew = { ... }: {
    imports = [ config.flake.modules.darwin.homebrew ];
  };
}
