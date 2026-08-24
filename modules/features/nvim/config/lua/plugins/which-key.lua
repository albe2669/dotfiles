-- which-key.nvim: popup showing available keybindings as you type.
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      delay = function(ctx)
        return ctx.timeout or 300
      end,
      filter = function(mapping)
        return mapping.desc and mapping.desc ~= ""
      end,
      spec = {
        { "<leader>l", group = "LSP" },
        { "<leader>h", group = "Git hunk" },
        { "<leader>d", group = "Debug" },
        { "<leader>t", group = "Toggle" },
      },
    },
  },
}
