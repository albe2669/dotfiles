{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}: let
  kotlin-nvim = pkgs-unstable.vimUtils.buildVimPlugin {
    pname = "kotlin.nvim";
    version = "unstable-" + builtins.substring 0 7 inputs.kotlin-nvim.rev;
    src = inputs.kotlin-nvim;
  };

  # Server discovery: kotlin.nvim finds the server through $KOTLIN_LSP_DIR,
  # which must contain bin/intellij-server.
  kotlin-lsp = pkgs.callPackage ../../../../pkgs/kotlin-lsp {};
in {
  programs.nixvim.extraPlugins = [kotlin-nvim];

  programs.nixvim.extraConfigLua =
    /*
    lua
    */
    ''
      vim.env.KOTLIN_LSP_DIR = "${kotlin-lsp}/share/kotlin-lsp"
      require("kotlin").setup({})
    '';
}
