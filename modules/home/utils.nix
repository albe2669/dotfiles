{pkgs, ...}: {
  home.packages = with pkgs; [
    # Tools
    bat
    eza
    gnutar
    hyperfine
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
    mesa-demos  # Renamed from glxinfo
    brightnessctl
  ];
}
