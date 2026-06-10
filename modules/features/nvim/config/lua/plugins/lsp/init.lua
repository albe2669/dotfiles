local lu = require("plugins.lsp.lsp-utils")

local border_opts = { border = "single", focusable = false, scope = "line" }

vim.o.winborder = "single"
vim.diagnostic.config({ virtual_text = true, float = border_opts })

global.lsp = {
  border_opts = border_opts,
  formatting = lu.formatting,
}

local opts = {
  automatic_installation = true,
  ensure_installed = {}
}

local dependencies = {
  "williamboman/mason.nvim",
  -- Note: We keep neovim/nvim-lspconfig for the LSP configs (now in lsp/ directory)
  -- but we use vim.lsp.config() instead of require('lspconfig') framework
  "neovim/nvim-lspconfig",
}

local servers = lu.load_servers({
  "bash-server",
  "c-server",
  "clojure-server",
  "cmake-server",
  "dagger-server",
  "eslint-server",
  "erlang-server",
  "go-server",
  "graphql-server",
  -- "java-server",
  "json-server",
  "latex-server",
  "lua-server",
  "nix-server",
  "opentofu-server",
  "python-server",
  "rs-server",
  "svelte-server",
  "tailwindcss-server",
  -- "terraform-server",
  "ts-server",
  "vue-server",
  "yaml-server",
  "yuck-server",
})

for _, server in pairs(servers) do
  if type(server.server_name) == "table" then
    lu.merge_arrays(opts.ensure_installed, server.server_name)
  elseif server.server_name ~= "" and server.dont_install ~= true then
    table.insert(opts.ensure_installed, server.server_name)
  end

  if server.dependencies then
    lu.merge_arrays(dependencies, server.dependencies)
  end
end

-- Note: We no longer hide lspconfig messages since we're using vim.lsp.config() directly

return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = dependencies,
    lazy = false,
    config = function()
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        }
      })
      require("mason-lspconfig").setup(opts)

      -- Apply blink.cmp-enriched capabilities to every LSP server by default.
      vim.lsp.config("*", { capabilities = lu.capabilities() })

      for _, server in pairs(servers) do
        server.setup(lu.on_attach)
      end
    end
  }
}
