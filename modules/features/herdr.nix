{config, ...}: {
  flake.modules.homeManager.herdr = {
    inputs,
    system,
    pkgs-unstable,
    ...
  }: let
    toml = pkgs-unstable.formats.toml {};
  in {
    home.packages = [
      inputs.llm-agents.packages.${system}.herdr
    ];

    xdg.configFile."herdr/config.toml".source = toml.generate "herdr-config" {
      theme.name = "terminal";

      keys = {
        prefix = "ctrl+f";

        # zellij tmux-mode entry letters -> herdr actions. Herdr's
        # prefix is transient, so Esc cancels and Ctrl f has no
        # passthrough equivalent; both are intentionally omitted.

        # g -> Locked: herdr's session navigator (default binding).
        goto = "prefix+g";

        # p -> Pane: cycle panes (zellij's Pane mode manages panes).
        cycle_pane_next = "prefix+p";

        # t -> Tab: create a tab (zellij's Tab mode creates/switches).
        new_tab = "prefix+t";
        next_tab = "prefix+right";
        previous_tab = "prefix+left";

        # n -> Resize: herdr has a dedicated resize mode.
        resize_mode = "prefix+n";

        # h -> Move: swap panes vim-style (zellij's Move mode reorders).
        swap_pane_left = "prefix+shift+h";
        swap_pane_down = "prefix+shift+j";
        swap_pane_up = "prefix+shift+k";
        swap_pane_right = "prefix+shift+l";

        # s -> Scroll: herdr's copy mode opens the scrollback viewer.
        copy_mode = "prefix+s";

        # o -> Session: open the workspace picker.
        workspace_picker = "prefix+o";

        # q -> Quit: detach exits the herdr client.
        detach = "prefix+q";

        # tmux-style splits: " = stacked (horizontal), % = side-by-side (vertical).
        split_horizontal = "prefix+double_quote";
        split_vertical = "prefix+percent";

        command = [
          # Lazygit in a session-modal popup.
          {
            key = "prefix+shift+g";
            type = "popup";
            command = "lazygit";
            description = "run lazygit";
            width = "80%";
            height = "80%";
          }
          {
            # Break the focused pane into a new tab (tmux break-pane).
            key = "prefix+!";
            type = "shell";
            command = ''$HERDR_BIN_PATH pane move "$HERDR_ACTIVE_PANE_ID" --new-tab --focus'';
            description = "break pane into new tab";
          }
        ];
      };
    };
  };

  flake.modules.combined.herdr = _: {
    hm.imports = [
      config.flake.modules.homeManager.herdr
    ];
  };
}
