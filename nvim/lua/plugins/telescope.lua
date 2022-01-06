local utils = require("utils")

local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close,
      },
      i = {
        ["<Esc>"] = actions.close,
      }
    },
  }
}

utils.nmap("<c-p>", "<cmd>Telescope find_files<cr>")
utils.nmap(";r", "<cmd>Telescope live_grep<cr>")
utils.nmap("\\\\", "<cmd>Telescope buffers<cr>")
utils.nmap(";;", "<cmd>Telescope help_tags<cr>")


