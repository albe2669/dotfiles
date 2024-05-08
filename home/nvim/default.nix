{
  pkgs,
  config,
  lib,
  variables,
  ...
}: {
  home.packages = with pkgs; [
    curl # for vimplug
    neovim
    virtualenv
    xclip
    lazygit
    tree-sitter
    stdenv.cc
  ];

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/nvim/config");
  };
}
