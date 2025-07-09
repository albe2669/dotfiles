{pkgs, ...}: {
  home.packages = with pkgs; [
    # Tools
    flameshot # screenshot

    # Networks
    networkmanagerapplet
  ];
}
