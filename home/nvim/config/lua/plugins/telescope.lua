return {
  {
    "nvim-telescope/telescope-media-files.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim", "telescope-media-files.nvim", "nvim-telescope/telescope-ui-select.nvim" },
    lazy = false,
    config = function()
      local actions = require("telescope.actions")

      local opts = {
        defaults = {
          mappings = {
            n = {
              ["q"] = actions.close,
            },
            i = {
              ["<Esc>"] = actions.close,
            }
          },
        },
        pickers = {
          find_files = {
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob",
              "!.git/",
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("media_files")
      telescope.load_extension("ui-select")
    end,
    init = function()
      local utils = require("utils")

      utils.nmap("<c-p>", "<cmd>Telescope find_files<cr>")
      utils.nmap(";r", "<cmd>Telescope live_grep<cr>")
      utils.nmap("\\\\", "<cmd>Telescope buffers<cr>")
      utils.nmap(";;", "<cmd>Telescope help_tags<cr>")
    end,
  }
}
