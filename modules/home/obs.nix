{pkgs-unstable, ...}: {
  home.packages = with pkgs-unstable; [
    obs-studio
  ];
}
