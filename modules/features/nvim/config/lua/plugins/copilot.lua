-- copilot.lua: the maintained Lua rewrite of Copilot for Neovim.
-- Inline ghost text / panel are disabled because Copilot is surfaced through
-- blink.cmp (via blink-copilot) as a normal completion source instead.
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
    },
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-l>",
          }
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          gitcommit = true,
          yaml = true,
          ["*"] = true,
        },
        nes = {
          enable = true,
          keymap = {
            accept_and_goto = "C-p",
            accept = false,
            dismiss = "<Esc>",
          }
        }
      })

      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "BlinkCmpMenuOpen",
      --   callback = function()
      --     vim.b.copilot_suggestion_hidden = true
      --   end,
      -- })
      --
      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "BlinkCmpMenuClose",
      --   callback = function()
      --     vim.b.copilot_suggestion_hidden = false
      --   end,
      -- })
    end,
  },
}
