{
  programs.nixvim.plugins.copilot-lua = {
    enable = true;
    settings = {
      suggestion = {
        auto_trigger = true;
        keymap.accept = "<C-l>";
      };
      filetypes = {
        markdown = true;
        gitcommit = true;
        yaml = true;
        "*" = true;
      };
    };
  };
}
