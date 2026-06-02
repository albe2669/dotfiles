{
  config,
  lib,
  ...
}: {
  home = {
    inherit (config.opts.variables) username stateVersion;
    homeDirectory = config.opts.variables.homeDirectory.path;

    activation = {
      createDirs = lib.hm.dag.entryAfter ["writeBoundary"] (builtins.concatStringsSep "\n" (builtins.map (dir: "mkdir -p ~/${dir}") config.opts.variables.homeDirectory.directories));
    };
  };

  programs.home-manager.enable = true;

  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
}
