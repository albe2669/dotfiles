return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_better_performance = 1
      vim.g.everforest_background = "hard"
      vim.g.everforest_transparent_background = 1
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_spell_foreground = "colored"
      vim.g.everforest_diagnostic_text_highlight = 1 -- If errors/info/warning looks strange, this highlights background
      vim.g.everforest_diagnostic_line_highlight = 1 -- If errors/info/warning looks strange, this highlights the line
      vim.g.everforest_diagnostic_virtual_text = "grey"

      vim.cmd([[colorscheme everforest]])
    end
  },
}
