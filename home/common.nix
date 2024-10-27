{
  variables,
  lib,
  ...
}: {
  home = {
    inherit (variables) username stateVersion;
    homeDirectory = variables.homeDirectory.path;

    activation = {
      createDirs = lib.hm.dag.entryAfter ["writeBoundary"] (builtins.concatStringsSep "\n" (builtins.map (dir: "mkdir -p ~/${dir}") variables.homeDirectory.directories));
    };
  };

  programs.home-manager.enable = true;
}
