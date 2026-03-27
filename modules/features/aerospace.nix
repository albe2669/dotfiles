{config, ...}: let
  flakeConfig = config;
in {
  flake.modules.darwin.aerospace = {lib, ...}: {
    system.defaults = {
      dock = {
        expose-animation-duration = lib.mkDefault 0.0;
      };

      NSGlobalDomain = {
        NSAutomaticWindowAnimationsEnabled = lib.mkDefault false;
      };

      spaces.spans-displays = lib.mkDefault true;

      CustomUserPreferences = {
        NSGlobalDomain.NSWindowShouldDragOnGesture = true;
      };
    };
  };

  flake.modules.homeManager.aerospace = {pkgs, ...}: {
    home.packages = [
      pkgs.raycast
    ];

    programs.aerospace = {
      enable = true;
      launchd.enable = true;

      userSettings = {
        automatically-unhide-macos-hidden-apps = true;
        key-mapping.preset = "qwerty";
        on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];

        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";

        accordion-padding = 30;

        exec.inherit-env-vars = true;
        exec-on-workspace-change = [];

        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.left = 8;
          outer.bottom = 8;
          outer.top = 8;
          outer.right = 8;
        };

        mode.main.binding = {
          alt-enter = "exec-and-forget open -na kitty";

          alt-shift-q = "close";
          alt-f = "fullscreen";
          alt-shift-space = "layout floating tiling";

          alt-slash = "layout tiles horizontal vertical";
          alt-comma = "layout accordion horizontal vertical";

          alt-esc = ''exec-and-forget osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}' '';
          alt-shift-r = "reload-config";
          alt-shift-e = "mode quit-confirm";

          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";

          alt-left = "focus left";
          alt-down = "focus down";
          alt-up = "focus up";
          alt-right = "focus right";

          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";

          alt-shift-left = "move left";
          alt-shift-down = "move down";
          alt-shift-up = "move up";
          alt-shift-right = "move right";

          alt-ctrl-h = "move-node-to-monitor left";
          alt-ctrl-j = "move-node-to-monitor down";
          alt-ctrl-k = "move-node-to-monitor up";
          alt-ctrl-l = "move-node-to-monitor right";

          alt-ctrl-left = "move-node-to-monitor left";
          alt-ctrl-down = "move-node-to-monitor down";
          alt-ctrl-up = "move-node-to-monitor up";
          alt-ctrl-right = "move-node-to-monitor right";

          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          alt-5 = "workspace 5";
          alt-6 = "workspace 6";
          alt-7 = "workspace 7";
          alt-8 = "workspace 8";
          alt-9 = "workspace 9";

          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";

          alt-minus = "resize smart -50";
          alt-equal = "resize smart +50";

          alt-tab = "workspace-back-and-forth";
          alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

          alt-ctrl-u = ''exec-and-forget osascript -e 'tell application "System Events" to keystroke space using {control down}' '';
          alt-ctrl-d = ''exec-and-forget osascript -e 'tell application "System Events" to keystroke space using {control down}' '';

          alt-shift-semicolon = "mode service";
          alt-shift-p = "mode passthrough";

          cmd-h = [];
          cmd-alt-h = [];
        };

        mode.service.binding = {
          esc = ["reload-config" "mode main"];
          r = ["flatten-workspace-tree" "mode main"];
          f = ["layout floating tiling" "mode main"];
          backspace = ["close-all-windows-but-current" "mode main"];

          alt-shift-h = ["join-with left" "mode main"];
          alt-shift-j = ["join-with down" "mode main"];
          alt-shift-k = ["join-with up" "mode main"];
          alt-shift-l = ["join-with right" "mode main"];
        };

        mode.quit-confirm.binding = {
          y = ["exec-and-forget aerospace enable off" "mode main"];
          enter = ["exec-and-forget aerospace enable off" "mode main"];
          esc = "mode main";
          n = "mode main";
        };

        mode.passthrough.binding = {
          alt-shift-p = "mode main";
        };

        on-window-detected = [
          {
            "if".app-name-regex-substring = "jetbrains";
            run = ["layout floating"];
          }
        ];
      };
    };
  };

  flake.modules.combined.aerospace = {config, ...}: {
    imports = [flakeConfig.flake.modules.darwin.aerospace];
    hm.imports = [flakeConfig.flake.modules.homeManager.aerospace];
  };
}
