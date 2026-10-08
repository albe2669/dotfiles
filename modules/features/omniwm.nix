{
  category = "System software";
  name = "omniwm";

  homeManager = {
    inputs,
    lib,
    config,
    ...
  }: let
    inherit (inputs.omniwm.lib) hotkeys colors workspaces;

    unassignedHotkeys = lib.genAttrs (map (
        hotkey: hotkey.id
      )
      (lib.importTOML "${inputs.omniwm}/settings-defaults.toml").hotkeys) (_: "Unassigned");

    theme = config.opts.theme.colors;
  in {
    imports = [inputs.omniwm.homeManagerModules.default];

    programs.omniwm = {
      enable = true;
      launchd.enable = true;

      # Monitor overrides and routing are machine state; the GUI owns them.
      preserveSettings = [
        "monitorBarOverrides"
        "monitorDwindleOverrides"
        "monitorGapOverrides"
        "monitorNiriOverrides"
        "monitorOrientationOverrides"
        "monitors"
        "routing"
      ];

      settings = {
        general = {
          ipcEnabled = lib.mkDefault true;
          defaultLayoutType = lib.mkDefault "dwindle";
        };

        focus = {
          followsMouse = lib.mkDefault true;
          raiseOnMouseFocus = lib.mkDefault true;
          followsWindowToMonitor = lib.mkDefault true;
          moveMouseToFocusedWindow = lib.mkDefault true;
          crossesMonitorAtEdge = lib.mkDefault true;
          moveCrossesMonitorAtEdge = lib.mkDefault true;
        };

        gaps = {
          size = lib.mkForce 10.0;
          outer = {
            left = lib.mkForce 12.0;
            right = lib.mkForce 12.0;
            top = lib.mkForce 12.0;
            bottom = lib.mkForce 12.0;
          };
        };

        dwindle = {
          smartSplit = lib.mkDefault true;
        };

        borders = {
          enabled = lib.mkDefault true;
          width = lib.mkForce 2.0;
          color = colors.fromHex theme.green;
          darkColor = colors.fromHex theme.aqua;
        };

        workspaceBar = {
          deduplicateAppIcons = lib.mkDefault true;
          hideEmptyWorkspaces = lib.mkDefault true;
          hideInNativeFullscreen = lib.mkDefault true;
          notchMode = lib.mkDefault "splitActiveLeft";
          notificationBadges = lib.mkDefault "dot";
          systemStatsButton = lib.mkDefault true;
          transparentBackground = lib.mkDefault true;
        };

        workspaces = workspaces [
          {
            displayName = "Browser";
            monitorAssignment.type = "tertiary";
          }
          {
            displayName = "IDE";
            monitorAssignment.type = "secondary";
          }
          {
            displayName = "Terminal";
            monitorAssignment.type = "secondary";
          }
          {displayName = "REST";}
          {}
          {displayName = "Docker";}
          {monitorAssignment.type = "secondary";}
          {displayName = "Slack";}
          {displayName = "Spotify";}
        ];

        # Option is Hyprland's SUPER. OmniWM accepts one binding per action, so
        # the Hyprland arrow-key duplicates of hjkl cannot be bound.
        hotkeys = hotkeys (
          unassignedHotkeys
          // {
            "focus.left" = "Option+H";
            "focus.down" = "Option+J";
            "focus.up" = "Option+K";
            "focus.right" = "Option+L";

            "move.left" = "Option+Shift+H";
            "move.down" = "Option+Shift+J";
            "move.up" = "Option+Shift+K";
            "move.right" = "Option+Shift+L";

            "moveWorkspaceToMonitor.left" = "Control+Option+H";
            "moveWorkspaceToMonitor.down" = "Control+Option+J";
            "moveWorkspaceToMonitor.up" = "Control+Option+K";
            "moveWorkspaceToMonitor.right" = "Control+Option+L";

            "switchWorkspace.0" = "Option+1";
            "switchWorkspace.1" = "Option+2";
            "switchWorkspace.2" = "Option+3";
            "switchWorkspace.3" = "Option+4";
            "switchWorkspace.4" = "Option+5";
            "switchWorkspace.5" = "Option+6";
            "switchWorkspace.6" = "Option+7";
            "switchWorkspace.7" = "Option+8";
            "switchWorkspace.8" = "Option+9";

            "moveToWorkspace.0" = "Option+Shift+1";
            "moveToWorkspace.1" = "Option+Shift+2";
            "moveToWorkspace.2" = "Option+Shift+3";
            "moveToWorkspace.3" = "Option+Shift+4";
            "moveToWorkspace.4" = "Option+Shift+5";
            "moveToWorkspace.5" = "Option+Shift+6";
            "moveToWorkspace.6" = "Option+Shift+7";
            "moveToWorkspace.7" = "Option+Shift+8";
            "moveToWorkspace.8" = "Option+Shift+9";

            "workspaceBackAndForth" = "Option+Tab";

            "resizeFocusedWindow.shrink" = "Option+Minus";
            "resizeFocusedWindow.grow" = "Option+Equal";

            "toggleFullscreen" = "Option+F";
            "closeFocusedWindow" = "Option+Shift+Q";
            "toggleFocusedWindowFloating" = "Option+Shift+Space";
            "toggleWorkspaceLayout" = "Option+Slash";
          }
        );
      };
    };
  };
}
