local opts = {
  check_ts = true,
  map_cr = true,
  disable_filetype = {
    "snacks_picker_input",
    "vim",
  },
}

return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup(opts)
      -- Completion-time bracket insertion is handled by blink.cmp
      -- (completion.accept.auto_brackets), so no cmp hook is needed here.
    end,
  },
}
