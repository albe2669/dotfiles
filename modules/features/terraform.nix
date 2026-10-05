{
  category = "Programming languages";
  name = "terraform";
  software = [
    "terraform-ls"
    "tflint"
    "opentofu"
    "terraform"
  ];

  homeManager = {
    pkgs,
    pkgs-unstable,
    ...
  }: {
    home.packages =
      [pkgs.opentofu]
      ++ (with pkgs-unstable; [
        terraform-ls
        tflint
        terraform
      ]);

    opts.editor.lsp.servers = {
      terraformls.enable = true;
      tflint.enable = true;
    };

    opts.tsGrammars = [
      pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars.tree-sitter-hcl
      pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars.tree-sitter-terraform
    ];
  };
}
