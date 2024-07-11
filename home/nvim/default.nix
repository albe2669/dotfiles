{
  pkgs,
  pkgs-unstable,
  config,
  variables,
  ...
}: let
  normalPackages = with pkgs; [
    curl # for vimplug
    virtualenv
    xclip
    stdenv.cc
  ];
in {
  home.packages = with pkgs-unstable;
    [
      neovim
      tree-sitter
    ]
    ++ normalPackages;

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/nvim/config");
  };
}
