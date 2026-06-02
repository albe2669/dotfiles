return {
  "NotAShelf/direnv.nvim",
  config = function()
    require("direnv").setup({
      -- Path to the direnv executable
      bin = "direnv",

      -- Whether to automatically load direnv when entering a directory with .envrc
      autoload_direnv = true,

      -- Statusline integration
      statusline = {
        -- Enable statusline component
        enabled = true,
        -- Icon to display in statusline
        icon = "󱚟",
      },

      -- Keyboard mappings
      keybindings = {
        allow = "<Leader>da",
        deny = "<Leader>dd",
        reload = "<Leader>dr",
        edit = "<Leader>de",
      },

      -- Notification settings
      notifications = {
        -- Log level (vim.log.levels.INFO, ERROR, etc.)
        level = vim.log.levels.INFO,
        -- Don't show notifications during autoload
        silent_autoload = true,
      }
    })
  end,
}
