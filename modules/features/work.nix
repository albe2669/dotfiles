{config, ...}: {
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
      set -x GOPRIVATE "github.com/corticph/*"
    '';

    programs.git.settings = {
      credential."https://github.com".helper = "!${lib.getExe pkgs.gh} auth git-credential";
      url."https://github.com/corticph" = {
        insteadOf = [
          "https://github.com/corticph"
          "ssh://git@github.com/corticph"
        ];
      };
    };
  };

  flake.modules.combined.work = {...}: {
    hm.imports = [config.flake.modules.homeManager.work];
  };
}
