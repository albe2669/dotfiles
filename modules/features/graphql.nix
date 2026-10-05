{
  category = "Programming languages";
  name = "graphql";
  software = [
    "graphql-language-service-cli"
  ];

  homeManager = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      graphql-language-service-cli
    ];

    opts.editor.lsp.servers.graphql.enable = true;

    opts.tsGrammars = [
      pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars.tree-sitter-graphql
    ];
  };
}
