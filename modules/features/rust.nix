{
  category = "Programming languages";
  name = "rust";
  software = [
    "cargo"
    "rustc"
    "rustfmt"
    "clippy"
    "rust-analyzer"
    "delve"
    "gdb"
    "kache"
  ];

  homeManager = {
    pkgs-unstable,
    system,
    inputs,
    lib,
    ...
  }: let
    kache = inputs.kache.packages."${system}".default;
  in {
    home.packages = with pkgs-unstable; [
      cargo
      rustc
      rustfmt
      clippy
      rust-analyzer
      delve
      gdb
      kache
    ];

    shell = {
      envVars = {
        RUST_BACKTRACE = "1";
        RUSTC_WRAPPER = "${lib.getExe kache}";
      };

      paths = [
        "${kache}/shims"
      ];
    };

    opts = {
      editor.lsp.servers.rust_analyzer = {
        enable = true;
        config = {
          check = {
            command = "clippy";
            extraArgs = ["--no-deps"];
          };
          cargo.features = "all";
          cargo.buildScripts.enable = true;
          procMacro.ignored = {
            leptos_macro = ["server"];
          };
        };
      };
      tsGrammars = [
        pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars.tree-sitter-rust
      ];
    };

    programs.nixvim.plugins.rustaceanvim = {
      enable = true;
      settings.server.default_settings = {
        check = {
          command = "clippy";
          extraArgs = ["--no-deps"];
        };
        cargo = {
          features = "all";
          buildScripts.enable = true;
        };
        procMacro.ignored = {
          leptos_macro = ["server"];
        };
      };
    };
  };
}
