{
  self,
  pkgs-unstable,
  pkgs,
	lib,
  ...
}: {
  home.packages = with pkgs-unstable; [
    act
    insomnia
    slack
  ];

  programs.fish.shellInit = ''
    set -x GIT_TOKEN (${lib.getExe pkgs.gh} auth token)
  '';
}
