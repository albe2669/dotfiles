{
  category = "Programming languages";
  name = "lua";
  software = [
    "lua"
    "lua-language-server"
  ];

  homeManager = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [
      lua5_1
      lua51Packages.luarocks
      lua-language-server
    ];

    opts = {
      editor.lsp.servers.lua_ls = {
        enable = true;
        config.settings.Lua = {
          telemetry.enable = false;
          runtime.version = "LuaJIT";
          diagnostics.globals = ["vim"];
          workspace.library = ["$VIMRUNTIME/lua"];
        };
      };
      tsGrammars = [
        pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars.tree-sitter-lua
      ];
    };
  };
}
