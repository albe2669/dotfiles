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
}
