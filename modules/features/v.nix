{
  category = "Programming languages";
  name = "v";
  software = [
    "v"
    "vls"
  ];

  homeManager = {
    lib,
    pkgs-unstable,
    ...
  }: let
    vls = pkgs-unstable.callPackage ../../pkgs/vls {};
  in {
    home.packages = [
      vls
      pkgs-unstable.vlang
    ];

    opts = {
      # Treesitter handles syntax highlighting for V; vls semantic tokens
      # only cover semantic categories and need an explicit start this
      # config omits.
      tsGrammars = [
        pkgs-unstable.vimPlugins.nvim-treesitter.builtGrammars.tree-sitter-v
      ];

      editor.lsp.servers.vls.enable = true;
    };

    # `v ls` cannot install vls itself: upstream publishes no macOS release
    # binaries and its source build needs a newer V than 0.5.2. Point the
    # launcher manifest at the Nix-built binary so `v ls` and nvim's default
    # `v ls` cmd work.
    home.activation.vlsManifest = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p "$HOME/.vls"
      printf '{"server_path": "%s"}\n' '${lib.getExe vls}' > "$HOME/.vls/vls.config.json"
      rm -rf "$HOME/.vls/src"
    '';
  };
}
