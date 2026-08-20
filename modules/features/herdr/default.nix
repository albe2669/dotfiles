{config, ...}: {
  flake.modules.homeManager.herdr = {
    inputs,
    lib,
    system,
    pkgs-unstable,
    config,
    ...
  }: let
    toml = pkgs-unstable.formats.toml {};

    base = config.lib.stylix.colors;
    hex = key: "#" + base."${key}-hex";
    grey2 = "#9da9a0";

    # Dotfiles/dirs copied from the source checkout into each new worktree.
    worktreeCopyFiles = [
      ".env"
      ".envrc"
      ".claude"
      ".omp"
      ".codegraph/.gitignore"
      ".codegraph/codegraph.db"
    ];

    # Popup script that prompts for a branch, creates the worktree through
    # herdr's API (so it is listed as a workspace), and copies the files
    # above from the source checkout into <project>/.worktrees/<branch>.
    worktreeCreateScript = pkgs-unstable.writeShellScriptBin "herdr-worktree-create" (
      builtins.readFile ./scripts/worktree-create.sh
    );
  in {
    home.packages = [
      inputs.llm-agents.packages.${system}.herdr
      worktreeCreateScript
    ];

    xdg.configFile."herdr/config.toml".source = toml.generate "herdr-config" {
      theme = {
        name = "terminal";
        custom = {
          accent = hex "base0B"; # highlights, active borders
          panel_bg = hex "base01"; # floating panels
          surface0 = hex "base02"; # selected/focused bg
          surface1 = hex "base02"; # dragged bg
          surface_dim = hex "base01"; # active workspace bg
          overlay0 = hex "base04"; # inactive branch, separators
          overlay1 = hex "base03"; # brighter overlay text
          text = hex "base05"; # active workspace name
          subtext0 = grey2; # inactive workspace name
          mauve = hex "base0E"; # active branch (was Gray)
          green = hex "base0B"; # done/idle
          yellow = hex "base0A"; # working/running
          red = hex "base08"; # blocked/attention
          blue = hex "base0D"; # unseen notification
          teal = hex "base0C"; # notification accent
          peach = hex "base09"; # interrupted/warning
        };
      };

      keys = {
        prefix = "ctrl+f";

        # Pane navigation: vim-style h/j/k/l (spatial).
        focus_pane_left = "prefix+h";
        focus_pane_down = "prefix+j";
        focus_pane_up = "prefix+k";
        focus_pane_right = "prefix+l";

        # Tab navigation: shift+h/l (left/right through the tab bar).
        previous_tab = "prefix+shift+h";
        next_tab = "prefix+shift+l";

        # Workspace navigation: shift+j/k (down/up the sidebar list).
        next_workspace = "prefix+shift+j";
        previous_workspace = "prefix+shift+k";

        # Agent navigation: alt+j/k (down/up the agent list).
        next_agent = "prefix+alt+j";
        previous_agent = "prefix+alt+k";

        # Swap panes: ctrl+h/j/k/l (vim spatial with ctrl modifier).
        swap_pane_left = "prefix+ctrl+h";
        swap_pane_down = "prefix+ctrl+j";
        swap_pane_up = "prefix+ctrl+k";
        swap_pane_right = "prefix+ctrl+l";

        # Cycle panes.
        cycle_pane_next = "prefix+tab";

        # g -> session navigator (default binding).
        goto = "prefix+g";

        # t -> new tab.
        new_tab = "prefix+t";

        # n -> resize mode.
        resize_mode = "prefix+n";

        # s -> copy mode (scrollback viewer).
        copy_mode = "prefix+s";

        # o -> workspace picker.
        workspace_picker = "prefix+o";

        # q -> detach.
        detach = "prefix+q";

        # tmux-style splits: " = stacked, % = side-by-side.
        split_horizontal = "prefix+double_quote";
        split_vertical = "prefix+percent";

        # new_worktree is a custom command below (prefix+shift+y).
        open_worktree = "prefix+shift+u";

        command = [
          # Create a project-local worktree (.worktrees/<branch>) that is
          # registered as a herdr workspace and seeded with dotfiles.
          # Replaces the built-in new_worktree keybind (prefix+shift+y).
          {
            key = "prefix+shift+y";
            type = "popup";
            command = ''HERDR_WORKTREE_BASE="main" HERDR_WORKTREE_COPY_FILES="${lib.concatStringsSep " " worktreeCopyFiles}" herdr-worktree-create'';
            description = "new worktree (local)";
            width = "60%";
            height = 8;
          }
          # Lazygit in a session-modal popup.
          {
            key = "prefix+shift+g";
            type = "popup";
            command = "lazygit";
            description = "run lazygit";
            width = "80%";
            height = "80%";
          }
          # Yazi file manager in a session-modal popup.
          {
            key = "prefix+shift+e";
            type = "popup";
            command = "yazi";
            description = "run yazi";
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
      # Sidebar spacing — add breathing room between top-level spaces.
      # Worktree children stay packed as a group (enforced upstream).
      ui = {
        sidebar.spaces.row_gap = 1;
      };
    };
  };

  flake.modules.combined.herdr = _: {
    hm.imports = [
      config.flake.modules.homeManager.herdr
    ];
  };
}
