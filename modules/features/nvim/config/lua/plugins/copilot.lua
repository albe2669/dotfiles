-- copilot.lua: the maintained Lua rewrite of Copilot for Neovim.
-- Inline ghost text / panel are disabled because Copilot is surfaced through
-- blink.cmp (via blink-copilot) as a normal completion source instead.
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          gitcommit = true,
          yaml = true,
          ["*"] = true,
        },
      })
    end,
  },
}
