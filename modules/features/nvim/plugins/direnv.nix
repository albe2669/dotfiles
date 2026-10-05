{
  inputs,
  pkgs-unstable,
  ...
}: let
  direnv-nvim = pkgs-unstable.vimUtils.buildVimPlugin {
    pname = "direnv.nvim";
    version = "unstable-" + builtins.substring 0 7 inputs.direnv-nvim.rev;
    src = inputs.direnv-nvim;
  };
in {
  programs.nixvim.extraPlugins = [direnv-nvim];

  programs.nixvim.extraConfigLua =
    /*
    lua
    */
    ''
      require("direnv").setup({
        bin = "direnv",
        autoload_direnv = true,
        statusline = {
          enabled = true,
          icon = "󱚟",
        },
        keybindings = {
          allow = "<Leader>da",
          deny = "<Leader>dd",
          reload = "<Leader>dr",
          edit = "<Leader>de",
        },
        notifications = {
          level = vim.log.levels.INFO,
          silent_autoload = true,
        },
      })
    '';
}
