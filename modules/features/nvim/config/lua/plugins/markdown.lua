return {
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup({
        instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
        port = 0,                   -- 0 = auto (8421 for takeover, OS-assigned for multi)
        open_browser = true,
        default_theme = "dark",     -- "dark" or "light"; initial preview theme
        debounce_ms = 300,
      })
    end,
    ft = { "markdown" },
  },
}
