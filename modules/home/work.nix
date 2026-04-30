{
  self,
  system,
  pkgs-unstable,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs-unstable; [
    act
    insomnia
    bruno
    bruno-cli
    slack
    self.packages.${system}.pup
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
}
