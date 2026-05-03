{ config, ... }: {
  flake.modules.homeManager.work = {
    pkgs-unstable,
    pkgs,
    lib,
    ...
  }: {
    home.packages =
      (with pkgs-unstable; [
        act
        insomnia
        bruno
        bruno-cli
        slack
      ])
      ++ [
        (pkgs.callPackage ../../pkgs/pup {})
      ];

    programs.fish.shellInit = ''
      set -x GIT_TOKEN (${lib.getExe pkgs.gh} auth token)
    '';
  };

  flake.modules.combined.work = { ... }: {
    hm.imports = [ config.flake.modules.homeManager.work ];
  };
}
