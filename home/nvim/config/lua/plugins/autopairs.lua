local opts = {
  check_ts = true,
  map_cr = true,
  disable_filetype = {
    "TelescopePrompt",
    "vim",
  },
}

return {
  {
    "windwp/nvim-autopairs",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("nvim-autopairs").setup(opts)

      -- Fix cmp completion
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
    end,
  },
}
