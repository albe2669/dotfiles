{config, ...}: {
  flake.modules.homeManager.ccstatusline = {
    self,
    system,
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.programs.ccstatusline;
    jsonFormat = pkgs.formats.json {};
  in {
    options.programs.ccstatusline = {
      enable = lib.mkEnableOption "ccstatusline, a configurable status line for Claude Code";

      package = lib.mkOption {
        type = lib.types.package;
        default = self.packages.${system}.ccstatusline;
        defaultText = lib.literalExpression "self.packages.\${system}.ccstatusline";
        description = "The ccstatusline package providing the {command}`ccstatusline` binary.";
      };

      settings = lib.mkOption {
        inherit (jsonFormat) type;
        default = {
          version = 3;
          lines = [
            [
              {
                id = "1";
                type = "model";
                color = "cyan";
              }
              {
                id = "2";
                type = "separator";
              }
              {
                id = "3";
                type = "context-length";
                color = "brightBlack";
              }
              {
                id = "4";
                type = "separator";
              }
              {
                id = "5";
                type = "git-branch";
                color = "magenta";
              }
              {
                id = "6";
                type = "separator";
              }
              {
                id = "7";
                type = "git-changes";
                color = "yellow";
              }
            ]
            []
            []
          ];
          flexMode = "full-minus-40";
          compactThreshold = 60;
          colorLevel = 2;
          inheritSeparatorColors = false;
          globalBold = false;
          gitCacheTtlSeconds = 5;
          minimalistMode = false;
          powerline = {
            enabled = false;
            separators = [""];
            separatorInvertBackground = [false];
            startCaps = [];
            endCaps = [];
            autoAlign = false;
            continueThemeAcrossLines = false;
          };
        };
        description = ''
          Configuration written verbatim to
          {file}`$XDG_CONFIG_HOME/ccstatusline/settings.json`.

          Each entry in `lines` is one status line (ccstatusline supports up to
          three) and each widget is an object with a `type` such as `model`,
          `separator`, `context-length`, `git-branch` or `git-changes`. Run
          {command}`ccstatusline` to browse every available widget and preview
          changes interactively.

          Because this file is managed by Nix it is a read-only symlink into the
          store, so the interactive editor cannot persist changes - edit this
          option instead.

          See <https://github.com/sirmalloc/ccstatusline>.
        '';
      };
    };

    config = lib.mkIf cfg.enable {
      home.packages = [cfg.package];

      xdg.configFile."ccstatusline/settings.json".source =
        jsonFormat.generate "ccstatusline-settings.json" cfg.settings;
    };
  };

  flake.modules.combined.ccstatusline = {...}: {
    hm.imports = [config.flake.modules.homeManager.ccstatusline];
  };
}
