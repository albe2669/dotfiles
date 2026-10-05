{
  programs.nixvim.plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add = {
          text = "▎";
        };
        change = {
          text = "▎";
        };
        delete = {
          text = "";
        };
        topdelete = {
          text = "";
        };
        changedelete = {
          text = "▎";
        };
        untracked = {
          text = "▎";
        };
      };
      current_line_blame = false;
    };
  };

  programs.nixvim.keymaps = [
    # Navigation between hunks
    {
      key = "]c";
      mode = "n";
      options = {
        desc = "Next git hunk";
      };
      action.__raw = ''
        function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() require("gitsigns").next_hunk() end)
          return "<Ignore>"
        end
      '';
    }
    {
      key = "[c";
      mode = "n";
      options = {
        desc = "Prev git hunk";
      };
      action.__raw = ''
        function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() require("gitsigns").prev_hunk() end)
          return "<Ignore>"
        end
      '';
    }

    # Actions
    {
      key = "<leader>hs";
      mode = [
        "n"
        "v"
      ];
      options.desc = "Stage hunk";
      action = ":Gitsigns stage_hunk<CR>";
    }
    {
      key = "<leader>hr";
      mode = [
        "n"
        "v"
      ];
      options.desc = "Reset hunk";
      action = ":Gitsigns reset_hunk<CR>";
    }
    {
      key = "<leader>hS";
      mode = "n";
      options.desc = "Stage buffer";
      action.__raw = ''function() require("gitsigns").stage_buffer() end'';
    }
    {
      key = "<leader>hu";
      mode = "n";
      options.desc = "Undo stage hunk";
      action.__raw = ''function() require("gitsigns").undo_stage_hunk() end'';
    }
    {
      key = "<leader>hR";
      mode = "n";
      options.desc = "Reset buffer";
      action.__raw = ''function() require("gitsigns").reset_buffer() end'';
    }
    {
      key = "<leader>hp";
      mode = "n";
      options.desc = "Preview hunk";
      action.__raw = ''function() require("gitsigns").preview_hunk() end'';
    }
    {
      key = "<leader>hb";
      mode = "n";
      options.desc = "Blame line";
      action.__raw = ''function() require("gitsigns").blame_line({full = true}) end'';
    }
    {
      key = "<leader>tb";
      mode = "n";
      options.desc = "Toggle line blame";
      action.__raw = ''function() require("gitsigns").toggle_current_line_blame() end'';
    }
    {
      key = "<leader>hd";
      mode = "n";
      options.desc = "Diff this";
      action.__raw = ''function() require("gitsigns").diffthis() end'';
    }
  ];
}
