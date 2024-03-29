local utils = require("utils")

local actions = require('telescope.actions')

require('telescope').load_extension('media_files')
require('telescope').setup({
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
})

utils.nmap("<c-p>", "<cmd>Telescope find_files<cr>")
utils.nmap(";r", "<cmd>Telescope live_grep<cr>")
utils.nmap("\\\\", "<cmd>Telescope buffers<cr>")
utils.nmap(";;", "<cmd>Telescope help_tags<cr>")


