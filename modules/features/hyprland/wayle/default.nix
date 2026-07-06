{
  config,
  lib,
  ...
}: let
  inherit (config.stylix) fonts;
  inherit (config.opts.theme) colors;

  # Copy base from the runtime.toml file
  base = import ./base.nix;
in {
  services.wayle = {
    enable = true;

    # Override the defualt settings with variables
    settings = lib.recursiveUpdate base {
      bar = {
        border-color = "${colors.fg}14"; # subtle ~8% fg hairline
      };
      general = {
        font-mono = fonts.monospace.name;
        font-sans = fonts.sansSerif.name;
      };
      styling = {
        # Everforest Dark Hard, shared with Hyprland via config.opts.theme.colors
        # so the bar and compositor stay in lockstep.
        palette = {
          bg = colors.bg_dim; # #232A2E - hard-dark base, as in the design
          surface = colors.bg0; # #2D353B
          elevated = colors.bg1; # #343F44
          fg = colors.fg; # #D3C6AA
          fg-muted = colors.grey2; # #9DA9A0
          primary = colors.green; # #A7C080 - the design's active accent
          green = colors.green; # #A7C080
          blue = colors.blue; # #7FBBB3
          red = colors.red; # #E67E80
          yellow = colors.yellow; # #DBBC7F
        };
      };
    };
  };

  xdg.configFile."wayle/styles/index.scss" = {
    source =
      config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}"
      + (builtins.toPath "/modules/features/hyprland/wayle/index.scss");
  };
}
