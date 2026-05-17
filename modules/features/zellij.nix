{config, ...}: {
  flake.modules.homeManager.zellij = {pkgs-unstable, ...}: {
    # stylix.targets.zellij.enable = true;

    programs.zellij = {
      enable = true;
      package = pkgs-unstable.zellij;
      enableFishIntegration = false;
      settings = {
        theme = "everforest-dark";

        keybinds = {
          "normal clear-defaults=true" = {
            "bind \"Ctrl f\"" = {
              SwitchToMode = ["Tmux"];
            };
            "unbind \"Ctrl b\"" = {};
          };
        };
        "tmux clear-defaults=true" = {
          "bind \"Ctrl f\"" = {
            Write = 2;
            SwitchToMode = "Normal";
          };
          "bind \"Esc\"" = {
            SwitchToMode = "Normal";
          };
          "bind \"g\"" = {
            SwitchToMode = "Locked";
          };
          "bind \"p\"" = {
            SwitchToMode = "Pane";
          };
          "bind \"t\"" = {
            SwitchToMode = "Tab";
          };
          "bind \"n\"" = {
            SwitchToMode = "Resize";
          };
          "bind \"h\"" = {
            SwitchToMode = "Move";
          };
          "bind \"s\"" = {
            SwitchToMode = "Scroll";
          };
          "bind \"o\"" = {
            SwitchToMode = "Session";
          };
          "bind \"q\"" = {
            Quit = {};
          };

          # bind "Ctrl f" { Write 2; SwitchToMode "Normal"; }
          # bind "Esc" { SwitchToMode "Normal"; }
          # bind "g" { SwitchToMode "Locked"; }
          # bind "p" { SwitchToMode "Pane"; }
          # bind "t" { SwitchToMode "Tab"; }
          # bind "n" { SwitchToMode "Resize"; }
          # bind "h" { SwitchToMode "Move"; }
          # bind "s" { SwitchToMode "Scroll"; }
          # bind "o" { SwitchToMode "Session"; }
          # bind "q" { Quit; }
        };
      };
    };
  };

  flake.modules.combined.zellij = {...}: {
    hm.imports = [config.flake.modules.homeManager.zellij];
  };
}
