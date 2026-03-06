{
  self,
  pkgs-unstable,
  pkgs,
  ...
}: {
  home.packages = with pkgs-unstable; [
    act
    insomnia
    slack
  ];

  programs.fish.shellInit = ''
    set -x GIT_TOKEN (${pkgs.gh} auth token)
  '';
}
