-- dropbar.nvim: breadcrumb navigation bar showing code context via LSP/treesitter.
return {
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = {
      bar = {
        sources = {
          function(buf, win)
            local ok, dropbar = pcall(require, "dropbar.sources")
            if not ok then return end
            local sources = {}
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
              if client.server_capabilities.documentSymbolProvider then
                table.insert(sources, dropbar.lsp)
                break
              end
            end
            table.insert(sources, dropbar.terminal)
            return sources
          end,
        },
      },
      icons = {
        ui = {
          bar = { separator = " > ", extends = "" },
        },
      },
    },
  },
}
