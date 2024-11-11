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
    lua5_1
    lua51Packages.luarocks
    lua-language-server
    rust-analyzer
  ];

in {
  home.packages = with pkgs-unstable;
    [
      neovim
      tree-sitter
      basedpyright
      ruff

      nodePackages."@vue/typescript-plugin"
    ]
    ++ normalPackages;

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/nvim/config");
  };
}
