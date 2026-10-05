{
  programs.nixvim.plugins.yazi = {
    enable = true;
    settings = {
      open_for_directories = false;
      keymaps.show_help = "<f1>";
      floating_window_scaling_factor = 0.85;
    };
  };

  programs.nixvim.keymaps = [
    {
      key = "<leader>e";
      mode = "n";
      options.desc = "Open yazi at the current file";
      action = "<cmd>Yazi<cr>";
    }
    {
      key = "<leader>cw";
      mode = "n";
      options.desc = "Open yazi in working directory";
      action = "<cmd>Yazi cwd<cr>";
    }
    {
      key = "<c-up>";
      mode = "n";
      options.desc = "Resume the last yazi session";
      action = "<cmd>Yazi toggle<cr>";
    }
  ];
}
