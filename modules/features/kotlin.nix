{
  category = "Programming languages";
  name = "kotlin";
  software = [
    "kotlin"
    "kotlin-lsp"
    "ktlint"
  ];

  homeManager = {
    self,
    system,
    pkgs,
    pkgs-unstable,
    ...
  }: {
    home.packages = [
      pkgs.kotlin
      self.packages.${system}.kotlin-lsp
      pkgs-unstable.ktlint
    ];

    # kotlin_lsp is started by nvim/plugins/kotlin.nix, which supplies the
    # workspace/configuration handler the server requires; a plain
    # vim.lsp.enable("kotlin_lsp") breaks completions and inlay hints.
    opts.tsGrammars = [
      pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars.tree-sitter-kotlin
    ];
  };
}
