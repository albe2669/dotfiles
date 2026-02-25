{
  self,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable; [
    act
    insomnia
    slack
    code
  ];

  programs.fish.shellInit = ''
    set -x GIT_TOKEN (gh auth token)
  '';
}
