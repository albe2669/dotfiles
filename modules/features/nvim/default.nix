{config, ...}: {
  flake.modules.homeManager.nvim = {
    pkgs,
    pkgs-unstable,
    lib,
    config,
    ...
  }: let
    normalPackages = with pkgs; [
      curl
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
        jdt-language-server
        google-java-format
        rust-analyzer
      ]
      ++ normalPackages
      ++ lib.optionals (!config.opts.variables.isDarwin) [
        wl-clipboard
      ];

    xdg.configFile.nvim = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/features/nvim/config");
    };
  };

  flake.modules.combined.nvim = {...}: {
    hm.imports = [config.flake.modules.homeManager.nvim];
  };
}
