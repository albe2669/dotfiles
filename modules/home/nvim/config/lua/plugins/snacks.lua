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
      image = { enabled = true },
    },
    keys = {
      { "<c-p>", function() Snacks.picker.files() end },
      { ";r",    function() Snacks.picker.grep() end },
      { "\\\\",  function() Snacks.picker.buffers() end },
      { ";;",    function() Snacks.picker.help() end },
    }
  },
}
