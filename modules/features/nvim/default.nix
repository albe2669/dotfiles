{config, ...}: let
  flakeConfig = config;
in {
  category = "Tools";
  name = "nvim";
  software = [
    "neovim"
  ];

  homeManager = {
    pkgs,
    pkgs-unstable,
    lib,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
  in {
    imports = with flakeConfig.flake.modules.homeManager; [
      go
      rust
      java
      nix-lang
      python3
      lua
      javascript
    ];

    home.packages = with pkgs-unstable;
      [
        neovim
      ]
      ++ (with pkgs; [
        curl
        stdenv.cc
      ])
      ++ lib.optionals (!config.opts.variables.isDarwin) [
        pkgs.wl-clipboard
      ];

    xdg.configFile.nvim = {
      source = helpers.mkDotfilesSymlink config "features/nvim/config";
    };
  };
}
