{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Tools
    exa
    gnutar
    ripgrep
    unzip

    # Convenience
    fd
    jump

    # System
    bandwhich
    bottom
    procs
  ];
}
