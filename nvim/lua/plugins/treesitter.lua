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
    "tsx",
    "toml",
    "json",
    "yaml",
    "html",
    "scss",
    "dockerfile",
    "go",
    "gomod",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "rust",
    "vim",
    "vue",
    "typescript",
    "http",
  },
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }

