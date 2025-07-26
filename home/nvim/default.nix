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
      nil
      gopls
      wl-clipboard
      tree-sitter
      basedpyright
      ruff
      csharp-ls
      roslyn-ls
    ]
    ++ normalPackages;

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.dotfilesLocation}" + (builtins.toPath "/home/nvim/config");
  };
}
