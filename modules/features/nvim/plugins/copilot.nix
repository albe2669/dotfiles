{
  programs.nixvim.plugins.copilot-lua = {
    enable = true;
    settings = {
      suggestion = {
        enabled = true;
        auto_trigger = true;
        keymap.accept = "<C-l>";
      };
      panel.enabled = false;
      filetypes = {
        markdown = true;
        gitcommit = true;
        yaml = true;
        "*" = true;
      };
    };
  };

  programs.nixvim.plugins.copilot-lsp = {
    enable = true;
    settings.nes = {
      move_count_threshold = 3;
    };
  };

  # NES accept-and-jump on <C-p>, dismiss on <Esc>, as in the old copilot.lua config.
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<C-p>";
      options.desc = "Accept Copilot NES suggestion";
      action.__raw = ''
        function()
          local nes = require("copilot-lsp.nes")
          local _ = nes.walk_cursor_start_edit()
            or (nes.apply_pending_nes() and nes.walk_cursor_end_edit())
        end
      '';
    }
    {
      mode = "n";
      key = "<Esc>";
      options.desc = "Clear Copilot NES suggestion";
      action.__raw = ''
        function()
          if not require("copilot-lsp.nes").clear() then
            vim.cmd("nohlsearch")
          end
        end
      '';
    }
  ];
}
