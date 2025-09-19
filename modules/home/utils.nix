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
    jq

    # Convenience
    fd
    zoxide

    # System
    bandwhich
    bottom
    procs
    glxinfo
    brightnessctl
  ];
}
