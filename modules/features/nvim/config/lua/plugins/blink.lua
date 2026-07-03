-- blink.cmp: a modern, fast (Rust fuzzy matcher) completion engine that
-- replaces nvim-cmp and the whole cmp-* / vsnip stack.
-- https://github.com/Saghen/blink.cmp
return {
  {
    "saghen/blink.cmp",
    -- Pull a tagged release so the prebuilt fuzzy-matcher binary is downloaded
    -- (no local Rust toolchain required).
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      -- "super-tab": Tab selects/accepts the current item (and jumps snippets),
      -- mirroring the old Tab-to-accept behaviour. <CR> still confirms.
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = true,
      },

      completion = {
        -- Insert function-call brackets when accepting LSP items.
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = { enabled = true },
        menu = {
          draw = {
            -- Treesitter-highlight the LSP completion labels.
            treesitter = { "lsp" },
            columns = {
              { "label",      "label_description", gap = 1 },
              { "kind_icon",  "kind",              gap = 1 },
              { "source_name" },
            },
          },
        },
      },

      signature = { enabled = true },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {},
      },

      -- Use the Rust implementation, downloading a prebuilt binary if needed.
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
