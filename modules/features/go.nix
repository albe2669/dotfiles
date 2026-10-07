{
  category = "Programming languages";
  name = "go";
  software = [
    "go"
    "golangci-lint"
    "gopls"
  ];

  homeManager = {pkgs-unstable, ...}: let
    go_pkg = pkgs-unstable.go_1_27;
  in {
    home.packages = [
      go_pkg
      pkgs-unstable.golangci-lint
      pkgs-unstable.gopls
    ];

    programs.fish.shellInit = ''
      set -x GOROOT "${go_pkg}/share/go"
    '';

    home.sessionVariables = {
      GOROOT = "${go_pkg}/share/go";
    };

    opts = {
      editor = {
        lsp.servers = {
          gopls.enable = true;
          golangci_lint_ls = {
            config.init_options.command = [
              "golangci-lint"
              "run"
              "--output.json.path"
              "stdout"
              "--show-stats=false"
              "--issues-exit-code=1"
            ];
          };
        };
      };

      tsGrammars = with pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars; [
        tree-sitter-go
        tree-sitter-gomod
      ];
    };
  };
}
