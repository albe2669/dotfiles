{
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        mode = "buffers";
        themable = true;
        diagnostics = "nvim_lsp";
        diagnostics_indicator.__raw = ''
          function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end
        '';
        show_buffer_close_icons = true;
        show_close_icon = false;
        separator_style = "slant";
        always_show_bufferline = true;
        offsets = [
          {
            filetype = "snacks_layout_box";
            text = "Explorer";
            highlight = "Directory";
            separator = true;
          }
        ];
        hover = {
          enabled = true;
          delay = 200;
          reveal = ["close"];
        };
      };
    };
  };

  # Tab-style navigation between buffers. <S-l>/<S-h> keep <Tab>/<C-i> free.
  programs.nixvim.keymaps =
    [
      {
        mode = "n";
        key = "<S-l>";
        action = ":BufferLineCycleNext<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<S-h>";
        action = ":BufferLineCyclePrev<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>bp";
        action = ":BufferLineTogglePin<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>bP";
        action = ":BufferLineGroupClose ungrouped<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>bo";
        action = ":BufferLineCloseOthers<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "[b";
        action = ":BufferLineMovePrev<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "]b";
        action = ":BufferLineMoveNext<CR>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = ":lua Snacks.bufdelete()<CR>";
        options.silent = true;
      }
    ]
    ++ (builtins.genList (
        # Jump straight to buffer N
        i: {
          mode = "n";
          key = "<leader>${toString (i + 1)}";
          action = ":BufferLineGoToBuffer ${toString (i + 1)}<CR>";
          options.silent = true;
        }
      )
      9);
}
