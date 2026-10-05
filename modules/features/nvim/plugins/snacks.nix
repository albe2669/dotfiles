{
  programs.nixvim.plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      quickfile.enabled = true;
      indent.enabled = true;
      input.enabled = true;
      notifier = {
        enabled = true;
        timeout = 3000;
      };
      scope.enabled = true;
      scroll.enabled = true;
      statuscolumn.enabled = true;
      words.enabled = true;
      image.enabled = true;
      picker = {
        enabled = true;
        ui_select = true;
        sources.files.hidden = true;
        # snacks reads keys positionally: [lhs, action, mode=...]. "close" action is
        # old docs; old config used "close"; both exist as actions.
        win.input.keys = {
          "<Esc>" = {
            __unkeyed-1 = "close";
            mode = ["i" "n"];
          };
          q = {
            __unkeyed-1 = "close";
            mode = "n";
          };
        };
      };
      dashboard = {
        enabled = true;
        preset = {
          keys = [
            {
              icon = "";
              key = "f";
              desc = "Find File";
              action = ":lua Snacks.dashboard.pick('files')";
            }
            {
              icon = "";
              key = "n";
              desc = "New File";
              action = ":ene | startinsert";
            }
            {
              icon = "";
              key = "g";
              desc = "Find Text";
              action = ":lua Snacks.dashboard.pick('live_grep')";
            }
            {
              icon = "";
              key = "r";
              desc = "Recent Files";
              action = ":lua Snacks.dashboard.pick('oldfiles')";
            }
            {
              icon = "";
              key = "c";
              desc = "Config";
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})";
            }
            {
              icon = "";
              key = "q";
              desc = "Quit";
              action = ":qa";
            }
          ];
          header = ''
             ██████╗  ██████╗  ██████╗ ███████╗███████╗
            ██╔════╝ ██╔═══██╗██╔═══██╗██╔════╝██╔════╝
            ██║  ███╗██║   ██║██║   ██║███████╗█████╗
            ██║   ██║██║   ██║██║   ██║╚════██║██╔══╝
            ╚██████╔╝╚██████╔╝╚██████╔╝███████║███████╗
             ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
          '';
        };
        sections = [
          {section = "header";}
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
          {
            pane = 2;
            icon = "";
            title = "Recent Files";
            section = "recent_files";
            indent = 2;
            padding = 1;
          }
          {
            __raw = ''
              function()
                local in_git = Snacks.git.get_root() ~= nil
                local cmds = {
                  {
                    title = "Open Issues",
                    cmd = "gh issue list -L 5",
                    key = "i",
                    action = function()
                      vim.fn.jobstart("gh issue list --web", { detach = true })
                    end,
                    icon = "",
                    height = 10,
                  },
                  {
                    icon = "",
                    title = "Open PRs",
                    cmd = "gh pr list -L 5",
                    key = "P",
                    action = function()
                      vim.fn.jobstart("gh pr list --web", { detach = true })
                    end,
                    height = 10,
                  },
                  {
                    icon = "",
                    title = "Git Status",
                    cmd = "git --no-pager diff --stat -B -M -C",
                    height = 10,
                  },
                }
                return vim.tbl_map(function(cmd)
                  return vim.tbl_extend("force", {
                    pane = 2,
                    section = "terminal",
                    enabled = in_git,
                    padding = 1,
                    ttl = 5 * 60,
                    indent = 3,
                  }, cmd)
                end, cmds)
              end
            '';
          }
          # Old "startup" section needs lazy.stats (lazy.nvim-only). Plain centered row instead.
          {
            align = "center";
            text = "";
          }
        ];
      };
    };
  };
  programs.nixvim.keymaps = [
    {
      key = "<c-p>";
      mode = "n";
      options.desc = "Find files";
      action.__raw = ''
        function() Snacks.picker.files() end
      '';
    }
    {
      key = ";r";
      mode = "n";
      options.desc = "Grep";
      action.__raw = ''
        function() Snacks.picker.grep() end
      '';
    }
    {
      key = "\\\\";
      mode = "n";
      options.desc = "Buffers";
      action.__raw = ''
        function() Snacks.picker.buffers() end
      '';
    }
    {
      key = ";;";
      mode = "n";
      options.desc = "Help";
      action.__raw = ''
        function() Snacks.picker.help() end
      '';
    }
    {
      key = "gI";
      mode = "n";
      options.desc = "LSP implementations";
      action.__raw = ''
        function() Snacks.picker.lsp_implementations() end
      '';
    }
    {
      key = "gy";
      mode = "n";
      options.desc = "LSP type definitions";
      action.__raw = ''
        function() Snacks.picker.lsp_type_definitions() end
      '';
    }
    {
      key = "<leader>gr";
      mode = "n";
      options.desc = "LSP references";
      action.__raw = ''
        function() Snacks.picker.lsp_references() end
      '';
    }
    {
      key = "<F8>";
      mode = "n";
      options.desc = "Lazygit";
      action.__raw = "function() Snacks.lazygit() end";
    }
    {
      key = "<F6>";
      mode = "n";
      options.desc = "Toggle terminal";
      action.__raw = "function() Snacks.terminal.toggle() end";
    }
    {
      key = "<leader>gb";
      mode = "n";
      options.desc = "Git browse";
      action.__raw = "function() Snacks.gitbrowse() end";
    }
    {
      key = "<leader>gl";
      mode = "n";
      options.desc = "Lazygit log";
      action.__raw = "function() Snacks.lazygit.log() end";
    }
    {
      key = "<leader>n";
      mode = "n";
      options.desc = "Notification history";
      action.__raw = "function() Snacks.notifier.show_history() end";
    }
    {
      key = "<leader>un";
      mode = "n";
      options.desc = "Dismiss notifications";
      action.__raw = "function() Snacks.notifier.hide() end";
    }
    {
      key = "<leader>.";
      mode = "n";
      options.desc = "Toggle scratch buffer";
      action.__raw = "function() Snacks.scratch() end";
    }
    {
      key = "<leader>cR";
      mode = "n";
      options.desc = "Rename file";
      action.__raw = "function() Snacks.rename.rename_file() end";
    }
    {
      key = "]]";
      mode = [
        "n"
        "t"
      ];
      options.desc = "Next reference";
      action.__raw = "function() Snacks.words.jump(vim.v.count1) end";
    }
    {
      key = "[[";
      mode = [
        "n"
        "t"
      ];
      options.desc = "Prev reference";
      action.__raw = "function() Snacks.words.jump(-vim.v.count1) end";
    }
  ];
}
