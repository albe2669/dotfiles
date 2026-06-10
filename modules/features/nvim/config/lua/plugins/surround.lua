-- nvim-surround: maintained Lua replacement for tpope/vim-surround.
-- Keymaps (defaults): ys{motion}{char} add, ds{char} delete, cs{old}{new} change.
return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
}
