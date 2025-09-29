{
  pkgs-unstable,
  config,
  lib,
  ...
}:
{
  stylix.targets.yazi.enable = true;

  home.packages = with pkgs-unstable; [
    exiftool
    mediainfo
    poppler_utils
    ueberzugpp
    dragon-drop
    wl-clipboard
  ];

  programs.yazi = {
    enable = true;
    package = pkgs-unstable.yazi;
    enableFishIntegration = true;

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "<C-n>";
          run = "shell -- ${lib.getExe pkgs-unstable.dragon-drop} -x -i -T -A \"$@\"";
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
            run = "zen-beta '$@'";
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
}
