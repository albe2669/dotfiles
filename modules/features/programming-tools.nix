_: {
  category = "Programming tools";
  name = "programming-tools";
  software = [
    "just"
    "lefthook"
    "openssl"
    "pkg-config"
    "opentofu"
    "devenv"
    "tabularis"
  ];

  homeManager = {
    pkgs,
    pkgs-unstable,
    ...
  }: {
    home.packages = with pkgs; [
      just
      lefthook
      openssl
      pkg-config
      pkgs-unstable.devenv
      pkgs-unstable.tabularis
    ];

    opts = {
      editor = {
        lsp.servers = {
          bashls.enable = true;
          tofu_ls.enable = true;
        };
      };

      opts.tsGrammars = with pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars; [
        tree-sitter-bash
        tree-sitter-hcl
      ];
    };
  };
}
