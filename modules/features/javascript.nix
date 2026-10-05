{
  category = "Programming languages";
  name = "javascript";
  software = ["nodejs_22"];

  homeManager = {
    pkgs,
    pkgs-unstable,
    ...
  }: {
    home.packages = with pkgs; [
      nodejs_22
      pnpm
      bun
      pkgs-unstable.tailwindcss-language-server
      pkgs-unstable.svelte-language-server
    ];

    # Node-based LSP servers (ts_ls / vue_ls / eslint / emmet) use
    # npx at runtime; nothing to install here.
    opts = {
      editor = {
        lsp.servers = {
          ts_ls.enable = true;
          vue_ls = {
            enable = true;
            config.settings.html.format.wrapAttributes = "force-expand-multiline";
          };
          emmet_language_server = {
            enable = true;
            config.filetypes = ["html" "css" "scss" "less" "vue" "typescript"];
          };
          eslint.enable = true;
          tailwindcss.enable = true;
          svelte.enable = true;
        };
      };

      tsGrammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        tree-sitter-javascript
        tree-sitter-jsdoc
        tree-sitter-tsx
        tree-sitter-typescript
      ];
    };

    programs.nixvim.plugins.typescript-tools = {
      enable = true;
      settings = {
        filetypes = ["javascript" "typescript" "typescript.tsx" "vue"];
        single_file_support = false;
        tsserver_plugins = ["@vue/typescript-plugin"];
      };
    };
  };
}
