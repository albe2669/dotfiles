{config, ...}: {
  flake.modules.homeManager.omp = {
    self,
    lib,
    system,
    pkgs-unstable,
    config,
    ...
  }: let
    pkg = self.packages.${system}.omp;

    # Shared context — same source as Claude Code's context field.
    # Mounted as ~/.omp/agent/APPEND_SYSTEM.md so it is appended after
    # omp's built-in system prompt (skills, tool inventory, etc. are preserved).
    sharedContext = ../ai-shared/context.md;

    notifyScript = ''
      #!/usr/bin/env bash
      if [[ "$(uname)" == "Darwin" ]]; then
        osascript -e "display notification \"Agent stopped\" with title \"omp\""
      elif command -v notify-send &>/dev/null; then
        notify-send "omp" "Agent stopped"
      fi
    '';

    # YAML for ~/.omp/agent/config.yml.
    # Enterprise Anthropic auth is handled via environment variables — no secrets here:
    #   ANTHROPIC_API_KEY       – standard API key
    #   ANTHROPIC_OAUTH_TOKEN   – takes precedence over API key when set
    #   ANTHROPIC_BASE_URL      – custom gateway URL (corporate proxy)
    #   ANTHROPIC_CUSTOM_HEADERS – extra headers for the gateway (comma-separated "key: value")
    # Foundry / Azure gateway:
    #   CLAUDE_CODE_USE_FOUNDRY=true  FOUNDRY_BASE_URL=<url>  ANTHROPIC_FOUNDRY_API_KEY=<key>
    # Auth broker (centralised credential vault across machines):
    #   OMP_AUTH_BROKER_URL=<url>  OMP_AUTH_BROKER_TOKEN=<token>
    # Set these in SOPS-managed home.sessionVariables or in ~/.omp/agent/.env.
    configYaml = ''
      # oh-my-pi (omp) user configuration
      # Managed by Nix — do not edit by hand.

      # Match the model used by Claude Code
      modelRoles:
        default: anthropic/claude-sonnet-4-6

      # Tool approval mirrors Claude Code's broad allow-list approach.
      # "yolo" auto-approves all tools; restrict individual tools below if needed.
      tools:
        approvalMode: yolo
        approval:
          bash: allow

      # LSP — built-in; covers gopls, lua-ls, and others automatically
      lsp:
        enabled: true
        lazy: true
        diagnosticsOnWrite: true
        formatOnWrite: false

      bash:
        enabled: true

      # Desktop notifications when omp stops waiting for input
      ask:
        notify: on

      # Appearance
      statusLine:
        preset: default
        separator: powerline-thin
        sessionAccent: true

      # Use extended thinking for better quality (matches Claude Code's Sonnet defaults)
      defaultThinkingLevel: high

      # Automatic context compaction keeps long sessions healthy
      compaction:
        enabled: true
        strategy: context-full
        autoContinue: true

      # Eval backends — Python and JS repls are available as tools
      eval:
        py: true
        js: true
    '';
  in {
    home.packages =
      [pkg]
      ++ lib.optionals (builtins.match ".*-linux" system != null) [
        pkgs-unstable.libnotify
      ];

    # Main config
    home.file.".omp/agent/config.yml" = {
      text = configYaml;
    };

    # Shared context appended to omp's built-in system prompt.
    # Using APPEND rather than SYSTEM preserves omp's tool inventory and skill blocks.
    home.file.".omp/agent/APPEND_SYSTEM.md" = {
      source = sharedContext;
    };

    # Notification hook script (invoked manually or by extensions)
    home.file.".omp/hooks/notify.sh" = {
      executable = true;
      text = notifyScript;
    };

    programs.fish.shellInit = ''
      # Create a new branch worktree and open it in omp
      function ompw
        if test (count $argv) -lt 1
          echo "Usage: ompw <branch> [base]"
          return 1
        end
        set branch $argv[1]
        set base "main"
        if test (count $argv) -ge 2
          set base $argv[2]
        end

        if not git rev-parse --verify $base > /dev/null 2>&1
          echo "Base branch $base does not exist."
          return 1
        end

        set path "./.omp/worktrees/$branch"
        if git rev-parse --verify $branch > /dev/null 2>&1
          echo "Branch $branch already exists. Please choose a different name."
          return 1
        end
        git worktree add -b $branch $path $base
        for file in ".env" ".claude/settings.local.json"
          if test -f $file
            mkdir -p $path/(dirname $file)
            cp $file $path/$file
          end
        end
        echo "Worktree for branch $branch created at $path"
        echo "Starting omp in $path..."
        cd $path && omp
      end

      # Check out an existing branch into a worktree and open it in omp
      function ompwe
        if test (count $argv) -ne 1
          echo "Usage: ompwe <existing-branch>"
          return 1
        end
        set branch $argv[1]
        set basepath "./.omp/worktrees"
        set path "$basepath/$branch"
        mkdir -p $basepath
        if not git rev-parse --verify $branch > /dev/null 2>&1
          echo "Branch $branch does not exist. Please choose an existing branch."
          return 1
        end
        git worktree add --checkout $path $branch
        for file in ".env" ".claude/settings.local.json"
          if test -f $file
            mkdir -p $path/(dirname $file)
            cp $file $path/$file
          end
        end
        echo "Worktree for branch $branch created at $path"
        echo "Starting omp in $path..."
        cd $path && omp
      end
    '';
  };

  flake.modules.combined.omp = {...}: {
    hm.imports = [config.flake.modules.homeManager.omp];
  };
}
