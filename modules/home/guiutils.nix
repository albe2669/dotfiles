{pkgs, ...}: {
  home.packages = with pkgs; [
    # Networks
    networkmanagerapplet
  ];
}
