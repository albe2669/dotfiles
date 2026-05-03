{ config, ... }:
{
  flake.modules.homeManager.yazi =
    {
      pkgs-unstable,
      config,
      lib,
      ...
    }:
    let
      isDarwin = config.opts.variables.isDarwin;
    in
    {
      stylix.targets.yazi.enable = true;

      home.packages =
        with pkgs-unstable;
        [
          exiftool
          mediainfo
          poppler-utils
          ueberzugpp
          ripdrag
        ]
        ++ lib.optionals (!isDarwin) [
          wl-clipboard
        ];

      programs.yazi = {
        enable = true;
        package = pkgs-unstable.yazi;
        enableFishIntegration = true;

        shellWrapperName = "y";

        keymap = {
          mgr.prepend_keymap = [
            {
              on = "<C-n>";
              run = "shell -- ${lib.getExe pkgs-unstable.ripdrag} --no-click --and-exit --icon-size 64 --target --all \"$@\"";
            }
            {
              on = "z";
              run = "plugin zoxide";
            }
            {
              on = "Z";
              run = "plugin fzf";
            }
            {
              on = "<C-u>";
              run = "shell --confirm 'unzip $@'";
              desc = "Unzip files";
            }
          ];
        };

        settings = {
          opener = {
            zen = [
              {
                run = "zen-beta \"$@\"";
                desc = "Zen";
              }
            ];
          };

          open.prepend_rules = [
            {
              mime = "image/*";
              use = [
                "open"
                "zen"
                "reveal"
              ];
            }
            {
              mime = "application/pdf";
              use = [
                "zen"
                "zathura"
                "open"
                "reveal"
              ];
            }
          ];

          preview = {
            max_width = 1920;
            max_height = 1080;
          };
        };
      };
    };

  flake.modules.combined.yazi =
    { ... }:
    {
      hm.imports = [ config.flake.modules.homeManager.yazi ];
    };
}
