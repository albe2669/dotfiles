-- WARNING: If for some reason you get an error related to not being able to load the rust-analyzer server dynamically then try and delete ~/.local/share/nvim/mason/bin/rust_analyzer. This file may exist and be first in the path compared to the one installed correctly by nix itself.

local opts = {
  server = {
    -- https://rust-analyzer.github.io/book/configuration.html
    default_settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
        },
        cargo = {
          features = "all",
        },
        procMacro = {
          ignored = {
            leptos_macro = {
              -- "component",
              "server",
            },
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
      version = "^9",
      lazy = false,
    },
  },
  setup = function(on_attach)
    opts.server.on_attach = on_attach
    vim.g.rustaceanvim = opts
  end,
}
