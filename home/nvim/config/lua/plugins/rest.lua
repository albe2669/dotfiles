local opts = {
  -- Skip SSL verification, useful for unknown certificates
  skip_ssl_verification = false,
  -- Highlight request on run
  highlight = {
    enable = true,
    timeout = 150,
  },
  result = {
    split = {
      -- Open request results in a horizontal split
      horizontal = true,
      -- Keep the http file buffer above|left when split horizontal|vertical
      in_place = true,
    },
    -- toggle showing URL, HTTP info, headers at top the of result window
    behavior = {
      show_info = {
        url = true,
        http_info = true,
        headers = true,
      },
    },
  },
  -- Jump to request line on run
  env_file = '.env',
  custom_dynamic_variables = {},
}

return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
    }
  },
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("rest-nvim").setup(opts)
    end,
  },
}

