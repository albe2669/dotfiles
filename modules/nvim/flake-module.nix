{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    virtualenv
    xclip
    lazygit
    tree-sitter
    stdenv.cc
  ];

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
