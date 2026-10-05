{
  category = "Tools";
  name = "nvim";

  homeManager = {
    config,
    pkgs-unstable,
    lib,
    ...
  }: {
    imports = [
      ./colorschemes.nix
      ./plugins/completion.nix
      ./plugins/gitsigns.nix
      ./plugins/which-key.nix
      ./plugins/ui.nix
      ./plugins/statusline.nix
      ./plugins/copilot.nix
      ./plugins/markdown.nix
      ./plugins/snacks.nix
      ./plugins/lsp.nix
      ./plugins/dap.nix
      ./plugins/yazi.nix
    ];
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;

      nixpkgs.config.allowUnfree = true;

      # Collect editor config (LSP servers, grammars) from language features
      imports = [
        (_: config.opts.editor)
      ];

      globals = {
        have_nerd_font = true;
      };

      clipboard = {
        register = "unnamedplus";
        providers.pbcopy.enable = config.opts.variables.isDarwin;
        providers.wl-copy.enable = !config.opts.variables.isDarwin;
      };

      opts = {
        encoding = "utf-8";
        fileencoding = "utf-8";
        number = true;
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        smarttab = true;
        autoindent = true;
        title = true;
        cursorline = true;
        visualbell = true;
        termguicolors = true;
        background = "dark";
        showcmd = true;
        cmdheight = 1;
        laststatus = 3;
        showtabline = 2;
        scrolloff = 10;
        winborder = "single";
        hlsearch = true;
        ignorecase = true;
        smartcase = true;
        history = 1000;
        confirm = true;
        whichwrap = "<,>,h,l,[,]";
        shell = "fish";
      };

      plugins = {
        treesitter = {
          enable = true;
          highlight.enable = true;
          grammarPackages = with pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars;
            [
              tree-sitter-json
              tree-sitter-yaml
              tree-sitter-toml
              tree-sitter-dockerfile
              tree-sitter-vim
              tree-sitter-markdown
              tree-sitter-scss
              tree-sitter-html
              tree-sitter-graphql
              tree-sitter-vue
              tree-sitter-cooklang
            ]
            ++ builtins.map (
              grammar:
              # nixpkgs grammar pkgs bundle upstream queries using `#is-not?` (no
              # nvim 0.12 handler) and sit before user config in rtp, so rtp
              # overrides never win. Drop the bundled copies; nvim-treesitter
              # ships clean versions for these languages.
                grammar.overrideAttrs (_: {
                  postInstall = ''
                    if [ -d "$out/queries" ]; then rm -rf "$out/queries"; fi
                  '';
                })
            )
            config.opts.tsGrammars;
        };

        nvim-surround.enable = true;
        nvim-autopairs.enable = true;
        comment.enable = true;
        leap.enable = true;
        direnv.enable = true;
        vim-dadbod.enable = true;
        vim-dadbod-ui.enable = true;
        neogen.enable = true;
        dropbar.enable = true;
        web-devicons.enable = true;
        mini-icons.enable = true;
        friendly-snippets.enable = true;
        wakatime.enable = true;
        visual-multi.enable = true;
        vimtex = {
          enable = true;
          settings = {
            view_method = "zathura";
            compiler_method = "latexmk";
          };
        };
        clangd-extensions = {
          enable = true;
          settings.server = {};
        };
      };
      # nixpkgs grammar packages bundle upstream query files using the
      # `#is-not?` predicate (no core handler on nvim 0.12), and the grammar
      # pack sits before user config in rtp, so overrides cannot win. Strip
      # the bundled queries; nvim-treesitter ships clean copies for these.
      extraFiles = {
        "queries/nix/highlights.scm".source = ./queries/nix/highlights.scm;
        "queries/javascript/highlights.scm".source = ./queries/javascript/highlights.scm;
      };

      keymaps = [
        # Insert blank line above/below
        {
          mode = "n";
          key = "<CR>";
          action = "o<ESC>";
        }
        {
          mode = "n";
          key = "<S-CR>";
          action = "O<ESC>";
        }
        # Swap word under cursor with next word
        {
          mode = "n";
          key = "gw";
          action.__raw = ''
            function()
              vim.cmd([[s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/]])
              vim.cmd("nohlsearch")
            end
          '';
        }
        # Terminal escape
        {
          mode = "t";
          key = "<ESC>";
          action = "<C-\\><C-n>";
        }
        # RestNvim (http ft)
        {
          mode = "n";
          key = "<leader>rs";
          action = "<Plug>RestNvim";
        }
        # Bufferline navigation
        {
          mode = "n";
          key = "<S-l>";
          action = ":BufferLineCycleNext<CR>";
        }
        {
          mode = "n";
          key = "<S-h>";
          action = ":BufferLineCyclePrev<CR>";
        }
        {
          mode = "n";
          key = "<leader>bp";
          action = ":BufferLineTogglePin<CR>";
        }
        {
          mode = "n";
          key = "<leader>bP";
          action = ":BufferLineGroupClose ungrouped<CR>";
        }
        {
          mode = "n";
          key = "<leader>bo";
          action = ":BufferLineCloseOthers<CR>";
        }
        {
          mode = "n";
          key = "[b";
          action = ":BufferLineMovePrev<CR>";
        }
        {
          mode = "n";
          key = "]b";
          action = ":BufferLineMoveNext<CR>";
        }
        {
          mode = "n";
          key = "<leader>bd";
          action = ":lua Snacks.bufdelete()<CR>";
        }
      ];

      extraConfigVim = ''
        " Transparent background highlights
        highlight Normal guibg=NONE ctermfg=255 ctermbg=NONE
        highlight Terminal guibg=NONE ctermfg=255 ctermbg=NONE
        highlight Todo ctermbg=NONE guibg=NONE cterm=bold gui=bold
        highlight FloatBorder ctermbg=NONE guibg=NONE
      '';

      autoCmd = [
        # Tabs stay tabs in makefiles
        {
          event = "FileType";
          pattern = ["make"];
          command = "setlocal noexpandtab";
        }
        {
          event = "TermOpen";
          command = "startinsert";
        }
        {
          event = "TermOpen";
          command = "setlocal nonumber norelativenumber";
        }
      ];
    };
  };
}
