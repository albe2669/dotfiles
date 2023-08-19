{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Tools
    ripgrep
    gnutar
    unzip
    exa

    # Convenience
    jump
    fd

    # System
    procs
    bandwhich
    bottom
  ];
}
