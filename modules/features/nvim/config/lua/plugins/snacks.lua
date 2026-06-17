return {
  {
    "folke/snacks.nvim",
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      'nvim-mini/mini.icons',
    },
    priority = 1000,
    lazy = false,
    opts = {
      -- A badass start screen.
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File",    action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File",     action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text",    action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config",       action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "L", desc = "Lazy",         action = ":Lazy",                                                                enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit",         action = ":qa" },
          },
          header = [[
 ██████╗  ██████╗  ██████╗ ███████╗███████╗
██╔════╝ ██╔═══██╗██╔═══██╗██╔════╝██╔════╝
██║  ███╗██║   ██║██║   ██║███████╗█████╗
██║   ██║██║   ██║██║   ██║╚════██║██╔══╝
╚██████╔╝╚██████╔╝╚██████╔╝███████║███████╗
 ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝╚══════╝]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          -- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
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
                icon = " ",
                height = 10,
              },
              {
                icon = " ",
                title = "Open PRs",
                cmd = "gh pr list -L 5",

                key = "P",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 10,
              },
              {
                icon = " ",
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
          end,
          { section = "startup" },
        },
      },

      -- Quality-of-life modules.
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      image = { enabled = true },

      picker = {
        enabled = true,
        -- Use dropdown style for ui-select equivalent (vim.ui.select)
        ui_select = true,
        sources = {
          files = {
            -- Mirror your rg command: hidden files, excluding .git/
            hidden = true,
            ignored = false,
            follow = false,
            exclude = { ".git" },
          },
        },
        matcher = {
          fuzzy = true,          -- use fuzzy matching
          smartcase = true,      -- use smartcase
          ignorecase = true,     -- use ignorecase
          sort_empty = false,    -- sort results when the search string is empty
          filename_bonus = true, -- give bonus for matching file names (last part of the path)
          file_pos = true,       -- support patterns like `file:line:col` and `file:line`
          -- the bonusses below, possibly require string concatenation and path normalization,
          -- so this can have a performance impact for large lists and increase memory usage
          cwd_bonus = false,     -- give bonus for matching files in the cwd
          frecency = false,      -- frecency bonus
          history_bonus = false, -- give more weight to chronological order
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "i", "n" } },
              ["q"] = { "close", mode = "n" },
            },
          },
        },
      },
    },
    keys = {
      { "<c-p>", function()
        local win = vim.api.nvim_get_current_win()
        local picker = Snacks.picker.files()
        if picker then picker.main = win end
      end },
      { ";r", function()
        local win = vim.api.nvim_get_current_win()
        local picker = Snacks.picker.grep()
        if picker then picker.main = win end
      end },
      { "\\\\", function()
        local win = vim.api.nvim_get_current_win()
        local picker = Snacks.picker.buffers()
        if picker then picker.main = win end
      end },
      { ";;", function()
        local win = vim.api.nvim_get_current_win()
        local picker = Snacks.picker.help()
        if picker then picker.main = win end
      end },
      { "gI", function()
        local win = vim.api.nvim_get_current_win()
        local picker = Snacks.picker.lsp_implementations()
        if picker then picker.main = win end
      end },
      { "gy", function()
        local win = vim.api.nvim_get_current_win()
        local picker = Snacks.picker.lsp_type_definitions()
        if picker then picker.main = win end
      end },
      { "<leader>gr", function()
        local win = vim.api.nvim_get_current_win()
        local picker = Snacks.picker.lsp_references()
        if picker then picker.main = win end
      end },

      -- Terminal + lazygit (replaces vim-floaterm).
      { "<F8>",       function() Snacks.lazygit() end,                 desc = "Lazygit" },
      { "<F5>",       function() Snacks.terminal() end,                desc = "Toggle terminal" },
      { "<F6>",       function() Snacks.terminal.toggle() end,         desc = "Toggle terminal" },
      { "<leader>gg", function() Snacks.lazygit() end,                 desc = "Lazygit" },
      { "<leader>gb", function() Snacks.gitbrowse() end,               desc = "Git browse (open in remote)" },
      { "<leader>gl", function() Snacks.lazygit.log() end,             desc = "Lazygit log" },

      -- Notifications + misc.
      { "<leader>n",  function() Snacks.notifier.show_history() end,   desc = "Notification history" },
      { "<leader>un", function() Snacks.notifier.hide() end,           desc = "Dismiss notifications" },
      { "<leader>.",  function() Snacks.scratch() end,                 desc = "Toggle scratch buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end,      desc = "Rename file" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next reference",             mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference",             mode = { "n", "t" } },
    },
  },
}
