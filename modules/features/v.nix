{
  category = "Programming languages";
  name = "v";
  software = [
    "v"
    "v-analyzer"
  ];

  homeManager = {
    lib,
    pkgs-unstable,
    ...
  }: let
    v = pkgs-unstable.callPackage ../../pkgs/vlang {};
    v-analyzer = v.vTools.analyzer;
  in {
    home.packages = [
      v
      v-analyzer
    ];

    opts = {
      # Treesitter handles syntax highlighting; v-analyzer adds semantic
      # tokens on top through the LSP client.
      tsGrammars = [
        pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars.tree-sitter-v
      ];

      editor.lsp.servers.v_analyzer.enable = true;

      # The treesitter-v grammar is built from v-analyzer's own tree_sitter_v,
      # but the shared grammar override in the nvim module strips its
      # queries (they use nvim-0.12-incompatible directives elsewhere).
      # v-analyzer's highlights query is clean, so install it into the
      # runtime; without it the grammar parses but nothing is colored.
      editor.extraFiles."queries/v/highlights.scm".source = "${v-analyzer}/queries/v/highlights.scm";
    };
  };
}
