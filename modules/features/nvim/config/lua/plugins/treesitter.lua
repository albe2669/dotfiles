-- nvim-treesitter's `main` branch is a full rewrite (requires Neovim 0.12+):
-- highlighting/indent are no longer plugin "modules", they're enabled directly
-- via core APIs. See https://github.com/nvim-treesitter/nvim-treesitter#readme
local ensure_installed = {
  "bash",
  "c",
  "c_sharp",
  "clojure",
  "cooklang",
  "dockerfile",
  "go",
  "gomod",
  "graphql",
  "hcl",
  "html",
  "http",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "latex",
  "lua",
  "markdown",
  "rust",
  "scala",
  "scss",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "yaml",
  "vim",
  "vue",
  "yuck",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.setup({})
      ts.install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
