{
  programs.nixvim.plugins.lsp = {
    enable = true;
    keymaps = {
      # Old on_attach maps; action = vim.lsp.buf.<action>
      lspBuf = {
        K = "hover";
        "<leader>lr" = "rename";
        "<leader>la" = "code_action";
        "<leader>lh" = "signature_help";
      };
      diagnostic = {
        "[a" = "goto_prev";
        "]a" = "goto_next";
        "<leader>ld" = "open_float";
      };
    };
  };

  programs.nixvim.diagnostic.settings = {
    virtual_text = true;
    float = {
      border = "single";
      scope = "line";
    };
  };
}
