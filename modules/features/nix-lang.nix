{
  category = "Programming languages";
  name = "nix-lang";
  software = [
    "nixd"
    "nil"
    "tree-sitter"
  ];

  homeManager = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      nixd
      nil
      tree-sitter
    ];

    opts = {
      editor.lsp.servers.nil_ls.enable = true;
      opts.tsGrammars = [
        pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars.tree-sitter-nix
      ];
    };
  };
}
