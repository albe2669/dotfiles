{pkgs-unstable, ...}: {
  home.packages = with pkgs-unstable; [
    prusa-slicer # Newest version is 2.8.0 this installs 2.7.4
    fritzing
    arduino-ide
    # kicad
  ];
}
