{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    virtualenv
    xclip
    lazygit
    tree-sitter
    stdenv.cc
  ];

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink ./config;
  };
}
