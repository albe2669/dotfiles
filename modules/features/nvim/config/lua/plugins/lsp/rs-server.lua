-- rustaceanvim v6: Rust tools (debugging, clippy, float errors) + rust-analyzer LSP.

local opts = {
  tools = {},
  server = {
    default_settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        cargo = {
          features = "all",
          buildScripts = { enable = true },
        },
        procMacro = {
          ignored = {
            leptos_macro = { "server" },
          },
        },
      },
    },
  },
}

return {
  server_name = {},
  dependencies = {
    {
      "mrcjkb/rustaceanvim",
      version = "^6",
      lazy = false,
    }
  },
  setup = function(on_attach)
    opts.server.on_attach = on_attach
    vim.g.rustaceanvim = opts
  end
}
