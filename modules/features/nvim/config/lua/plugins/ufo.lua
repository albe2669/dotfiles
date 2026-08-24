-- nvim-ufo: code folding with LSP and treesitter context.
return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function()
        return { "lsp", "treesitter" }
      end,
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
      },
      preview = {
        win_config = {
          border = "rounded",
          winhighlight = "Normal:Folded",
        },
      },
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,         desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end,        desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kinds" },
      { "zm", function() require("ufo").closeFoldsWith() end,       desc = "Close folds with" },
    },
  },
}
