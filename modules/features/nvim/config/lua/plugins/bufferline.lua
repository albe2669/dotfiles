-- bufferline.nvim: buffers rendered as tabs along the top, with LSP
-- diagnostics, close buttons and snacks-powered buffer deletion.
local u = require("utils")

return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          themable = true,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "slant",
          always_show_bufferline = true,
          offsets = {
            {
              filetype = "snacks_layout_box",
              text = "Explorer",
              highlight = "Directory",
              separator = true,
            },
          },
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
        },
      })

      -- Tab-style navigation between buffers. <S-l>/<S-h> are used (instead of
      -- <Tab>) so the jumplist binding on <Tab>/<C-i> stays intact.
      u.nmap("<S-l>", ":BufferLineCycleNext<CR>")
      u.nmap("<S-h>", ":BufferLineCyclePrev<CR>")
      u.nmap("<leader>bp", ":BufferLineTogglePin<CR>")
      u.nmap("<leader>bP", ":BufferLineGroupClose ungrouped<CR>")
      u.nmap("<leader>bo", ":BufferLineCloseOthers<CR>")
      u.nmap("[b", ":BufferLineMovePrev<CR>")
      u.nmap("]b", ":BufferLineMoveNext<CR>")
      -- Close the current buffer without wrecking the window layout (snacks).
      u.nmap("<leader>bd", ":lua Snacks.bufdelete()<CR>")

      -- Jump straight to buffer N
      for i = 1, 9 do
        u.nmap("<leader>" .. i, ":BufferLineGoToBuffer " .. i .. "<CR>")
      end
    end,
  },
}
