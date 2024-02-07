{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Tools
    eza
    gnutar
    pandoc
    ripgrep
    unzip

    # Convenience
    fd
    jump

    # Programming
    gh

    # System
    bandwhich
    bottom
    procs
  ];
}
