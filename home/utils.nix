{pkgs, ...}: {
  home.packages = with pkgs; [
    # Tools
    eza
    gnutar
    ripgrep
    unzip

    # Programming
    gh

    # Convenience
    fd
    jump

    # System
    bandwhich
    bottom
    procs
    glxinfo
    brightnessctl
  ];
}
