local opts = {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  auto_paris = { enable = true },
  context_commentstring = {
    enable = true,
    enable_autocmd = true,
  },
  ensure_installed = {
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
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter")

      config.setup(opts)
    end,
  },
}
