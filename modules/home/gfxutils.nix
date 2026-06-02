{pkgs, ...}: {
  home.packages = with pkgs; [
    mesa-demos # Renamed from glxinfo
  ];
}
