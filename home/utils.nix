{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Tools
    eza
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
