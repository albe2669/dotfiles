{
  pkgs,
  pkgs-unstable,
  config,
  ...
}: let
  normalPackages = with pkgs; [
    curl # for vimplug
    virtualenv
    stdenv.cc
    lua5_1
    lua51Packages.luarocks
    lua-language-server
  ];
in {
  home.packages = with pkgs-unstable;
    [
      neovim
      nil
      gopls
      tree-sitter
      basedpyright
      ruff
      # csharp-ls
      # roslyn-ls
      jdt-language-server
      google-java-format
      rust-analyzer
    ]
    ++ normalPackages
    ++ lib.optionals (!config.opts.variables.isDarwin) [
      wl-clipboard
    ];

  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/home/nvim/config");
  };
}
