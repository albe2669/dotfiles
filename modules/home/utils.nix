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
    gh-dash
    gnumake
    jq

    # Convenience
    fd
    zoxide

    # System
    bandwhich
    bottom
    procs
  ];
}
