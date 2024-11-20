{pkgs, ...}: {
  home.packages = with pkgs; [
    # Tools
    bat
    eza
    gnutar
    ripgrep
    unzip

    # Programming
    gh
    gnumake

    # Convenience
    fd
    jump

    # System
    bandwhich
    bottom
    procs
    glxinfo
    brightnessctl

    # Networks
    networkmanagerapplet
  ];
}
