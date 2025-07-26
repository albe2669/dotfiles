{
  config,
  lib,
  ...
}: {
  home = {
    inherit (config.variables) username stateVersion;
    homeDirectory = config.variables.homeDirectory.path;

    activation = {
      createDirs = lib.hm.dag.entryAfter ["writeBoundary"] (builtins.concatStringsSep "\n" (builtins.map (dir: "mkdir -p ~/${dir}") config.variables.homeDirectory.directories));
    };
  };

  programs.home-manager.enable = true;
}
