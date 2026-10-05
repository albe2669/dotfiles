{
  programs.nixvim.plugins.nvim-ufo = {
    enable = true;
    settings = {
      provider_selector.__raw = ''function() return {"lsp", "indent"} end'';
      open_fold_hl_timeout = 150;
      close_fold_kinds_for_ft.default = [
        "imports"
        "comment"
      ];
      preview.win_config.border = "rounded";
    };
  };

  programs.nixvim.opts.foldcolumn = "1";
  programs.nixvim.opts.foldlevel = 99;
  programs.nixvim.opts.foldlevelstart = 99;
  programs.nixvim.opts.foldenable = true;

  programs.nixvim.keymaps = [
    {
      key = "zR";
      mode = "n";
      options.desc = "Open all folds";
      action.__raw = ''function() require("ufo").openAllFolds() end'';
    }
    {
      key = "zM";
      mode = "n";
      options.desc = "Close all folds";
      action.__raw = ''function() require("ufo").closeAllFolds() end'';
    }
    {
      key = "zr";
      mode = "n";
      options.desc = "Open folds except kinds";
      action.__raw = ''function() require("ufo").openFoldsExceptKinds() end'';
    }
    {
      key = "zm";
      mode = "n";
      options.desc = "Close folds with";
      action.__raw = ''function() require("ufo").closeFoldsWith() end'';
    }
  ];
}
