local opts = function(cmp)
  return {
    -- Enable LSP snippets
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    completion = {
      completeopt = "menu,menuone,noinsert",
      get_trigger_characters = function(trigger_characters)
        return vim.tbl_filter(function(char)
          return char ~= " " and char ~= "\t" and char ~= "\n"
        end, trigger_characters)
      end,
    },
    mapping = {
      ['<C-o>'] = cmp.mapping.select_prev_item(),
      ['<C-p>'] = cmp.mapping.select_next_item(),
      -- Add tab support
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
      -- Go to next on Tab
      ["<Tab>"] = function(fallback)
        local copilot_keys = vim.fn['copilot#Accept']()
        if cmp.visible() then
          cmp.select_next_item()
        elseif copilot_keys ~= '' and type(copilot_keys) == 'string' then
          vim.api.nvim_feedkeys(copilot_keys, 'i', true)
        else
          fallback()
        end
      end,
      -- Go back on Shift+tab
      ["<S-Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
    },
    experimental = {
      ghost_text = true
    },
    -- Installed sources
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'path' },
      { name = 'buffer' },
      { name = 'omni ' },
    },
  }
end

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup(opts(cmp))
    end,
  }
}
