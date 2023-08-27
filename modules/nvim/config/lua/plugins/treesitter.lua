require('nvim-treesitter.configs').setup({
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
    "dockerfile",
    "go",
    "gomod",
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
  },
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
