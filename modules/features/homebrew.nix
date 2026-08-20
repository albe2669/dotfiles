_: {
  flake.modules.darwin.homebrew = {lib, ...}: {
    homebrew = {
      enable = lib.mkDefault true;
      onActivation = {
        autoUpdate = lib.mkDefault true;
        cleanup = lib.mkDefault "zap";
        extraFlags = ["--force-cleanup"];
      };
    };
  };
}
