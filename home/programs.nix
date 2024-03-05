{pkgs, ...}: {
  imports = [
    ./insomnia.nix
  ];

  home.packages = with pkgs; [
    discord
    spotify
  ];
}
