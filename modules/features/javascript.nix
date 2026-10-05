{
  category = "Programming languages";
  name = "javascript";
  software = ["nodejs_22"];

  homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      nodejs_22
      pnpm
      bun
    ];

    # Node-based LSP servers (ts_ls / vue_ls / eslint / emmet / graphql) use
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
