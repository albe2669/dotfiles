{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    virtualenv
    xclip
    lazygit
  ];

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
