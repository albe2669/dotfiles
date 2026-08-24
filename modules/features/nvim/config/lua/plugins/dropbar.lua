-- dropbar.nvim: breadcrumb navigation bar showing code context via LSP/treesitter.
return {
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require("dropbar").setup({
        bar = {
          sources = {
            require("dropbar.sources").lsp,
          },
        },
        icons = {
          ui = {
            bar = { separator = " > ", extends = "" },
          },
        },
      })
    end,
  },
}
