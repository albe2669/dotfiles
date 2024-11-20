local u = require("utils")

return {
  {
    "kelly-lin/ranger.nvim",
    config = function()
      require("ranger-nvim").setup({
        ui = {
          border = "rounded",
          height = 0.9,
          width = 0.8,
          x = 0.5,
          y = 0.5,
        },
      })

      u.nmap("<leader>e", "", {
        callback = function()
          require("ranger-nvim").open(true)
        end,
      })
    end,
  },
}
