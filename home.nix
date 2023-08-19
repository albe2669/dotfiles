{ config, pkgs, ... }:

{
  home.username = "goose";
  home.homeDirectory = "/home/goose";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    nodejs-16_x
  ];

  programs.bat = {
    enable = true;
    config = {
      theme = "GitHub";
      italic-text = "always";
    };
  };

  imports = [
    ./modules/fish/flake-module.nix
  ];
}
