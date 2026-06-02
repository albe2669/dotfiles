return {
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = true

      vim.g.copilot_filetypes = {
        markdown = true,
      }
    end,
  },
}
