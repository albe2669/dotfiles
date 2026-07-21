{config, ...}: {
  flake.modules.homeManager.omp = {
    self,
    inputs,
    lib,
    system,
    pkgs-unstable,
    config,
    ...
  }: let
    apiKeyEnvName = "CORTI_API_KEY";

    pkg = inputs.llm-agents.packages.${system}.omp.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs-unstable.makeWrapper];

      postFixup = ''
        wrapProgram $out/bin/omp \
          --run 'export ${apiKeyEnvName}=$(cat ${config.sops.secrets.corti_bearer.path})'
      '';
    });

    # Shared context — same source as Claude Code's context field.
    # Mounted as ~/.omp/agent/APPEND_SYSTEM.md so it is appended after
    # omp's built-in system prompt (skills, tool inventory, etc. are preserved).
    sharedContext = ../ai-shared/context.md;

    # Combined skills bundle.
    mkSkillsBundle = import ../../../lib/skills-bundle.nix lib pkgs-unstable;
    combinedSkillsBundle = import ../ai-shared/bundles/default.nix {
      inherit lib;
      pkgs = pkgs-unstable;
      inherit mkSkillsBundle;
    };

    notifyScript = ''
      #!/usr/bin/env bash
      if [[ "$(uname)" == "Darwin" ]]; then
        osascript -e "display notification \"Agent stopped\" with title \"omp\""
      elif command -v notify-send &>/dev/null; then
        notify-send "omp" "Agent stopped"
      fi
    '';

    modelsData = import ../ai-shared/models.nix;

    # Format the shared model definitions as YAML list items for the sops
    # template.  Each entry is indented 6 spaces to sit under `models:`
    # (4 spaces) in the rendered file.
    modelsYaml =
      lib.concatMapStringsSep "\n" (
        m:
          "      - id: \"${m.id}\"\n"
          + "        name: \"${m.name}\"\n"
          + "        reasoning: ${lib.boolToString m.reasoning}\n"
          + "        input: [${lib.concatMapStringsSep ", " (i: i) m.input}]\n"
          + "        contextWindow: ${toString m.contextWindow}\n"
          + "        cost: { input: ${toString m.cost.input}, output: ${toString m.cost.output}, cacheRead: ${toString m.cost.cacheRead}, cacheWrite: ${toString m.cost.cacheWrite} }"
      )
      modelsData.models;
  in {
    imports = [./theme.nix];
    home.packages =
      [
        pkg
        inputs.llm-agents.packages.${system}.codegraph
      ]
      ++ lib.optionals (builtins.match ".*-linux" system != null) [
        pkgs-unstable.libnotify
      ];

    # Main config
    home.file.".omp/agent/config.yml" = {
      source =
        config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}"
        + (builtins.toPath "/modules/features/omp/config.yml");
    };

    # MCP servers — out-of-store symlink like config.yml so edits are live.
    home.file.".omp/agent/mcp.json" = {
      source =
        config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}"
        + (builtins.toPath "/modules/features/omp/mcp.json");
    };

    # Skills — shared bundle with Claude Code (mattpocock/skills + custom).
    home.file.".omp/agent/skills".source = combinedSkillsBundle;

    sops.templates."models.yaml" = {
      content = ''
        providers:
          corti:
            baseUrl: ${config.sops.placeholder.corti_base_url}
            apiKey: ${apiKeyEnvName}
            api: openai-completions
            auth: apiKey
            models:
        ${modelsYaml}
      '';
      path = "${config.home.homeDirectory}/.omp/agent/models.yml";
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
      # Point ccusage at omp session logs (pi-format) so `ccusage daily`
      # and `ccusage pi daily` pick them up automatically.
      set -x PI_AGENT_DIR $HOME/.omp/agent/sessions

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
