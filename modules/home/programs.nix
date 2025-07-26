{pkgs, ...}: {
  imports = [
    ./insomnia.nix
  ];

  home.packages = with pkgs; [
    discord
    spotify
  ];

  programs.firefox = {
    enable = true;
    # TODO: Add extensions
  };
}
