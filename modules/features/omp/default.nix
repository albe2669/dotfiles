_: {
  flake.modules.homeManager.omp = {
    inputs,
    lib,
    system,
    pkgs-unstable,
    config,
    ...
  }: let
    helpers = import ../../../lib/helpers.nix;
    aiShared = import ../ai-shared/mkAiTool.nix lib pkgs-unstable;
    apiKeyEnvName = "CORTI_API_KEY";

    pkg = inputs.llm-agents.packages.${system}.omp.overrideAttrs (oldAttrs: {
      #   # Source from fork branch with oauth.scopes override support (PR #9199).
      #   # Remove this override once the PR merges and llm-agents.nix updates.
      #   src = pkgs-unstable.fetchFromGitHub {
      #     owner = "albe2669";
      #     repo = "oh-my-pi";
      #     rev = "9e4a782fc0a9b7daa01684943a3d2ec861b1e736";
      #     sha256 = "sha256-RfF1rl4oZF09gfNKIq+fUFjzJaJZmwUDioStM53RGZk=";
      #   };
      #   # Cargo deps are unchanged — the PR only touches TypeScript.
      #   cargoDeps = pkgs-unstable.rustPlatform.fetchCargoVendor {
      #     name = "omp-${oldAttrs.version}-cargo-vendor";
      #     src = pkgs-unstable.fetchFromGitHub {
      #       owner = "albe2669";
      #       repo = "oh-my-pi";
      #       rev = "9e4a782fc0a9b7daa01684943a3d2ec861b1e736";
      #       sha256 = "sha256-RfF1rl4oZF09gfNKIq+fUFjzJaJZmwUDioStM53RGZk=";
      #     };
      #     hash = "sha256-G4WAIm+LswZ/nyOZ03m0rmpZthht5H3MQ6hLM7AhF5Y=";
      #   };

      nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs-unstable.makeWrapper];

      postFixup = ''
        wrapProgram $out/bin/omp \
          --run 'export ${apiKeyEnvName}=$(cat ${config.sops.secrets.corti_bearer.path})'
      '';
    });

    modelsData = import ../ai-shared/models.nix;

    # Format the shared model definitions as YAML list items for the sops
    # template. Each entry is indented 6 spaces to sit under `models:`
    # (4 spaces) in the rendered file.
    modelsYaml =
      lib.concatMapStrings (
        m:
          "      - id: \"${m.id}\"\n"
          + "        name: \"${m.name}\"\n"
          + "        reasoning: ${lib.boolToString m.reasoning}\n"
          + "        input: [${lib.concatStringsSep ", " m.input}]\n"
          + "        contextWindow: ${toString m.contextWindow}\n"
          + "        cost: { input: ${toString m.cost.input}, output: ${toString m.cost.output}, cacheRead: ${toString m.cost.cacheRead}, cacheWrite: ${toString m.cost.cacheWrite} }\n"
          + lib.optionalString (m ? thinking) (
            "        thinking:\n"
            + "          mode: ${toString m.thinking.mode}\n"
            + "          efforts: [${lib.concatStringsSep ", " m.thinking.efforts}]\n"
          )
      )
      modelsData.models;
  in {
    imports = [
      ./theme.nix
      ./plugins.nix
    ];
    home.packages =
      [
        pkg
        inputs.llm-agents.packages.${system}.codegraph
        pkgs-unstable.bun
      ]
      ++ lib.optionals (builtins.match ".*-linux" system != null) [
        pkgs-unstable.libnotify
      ];

    # Main config
    xdg.configFile."omp/agent/config.yml" = {
      source = helpers.mkDotfilesSymlink config "features/omp/config.yml";
    };

    # MCP servers — out-of-store symlink like config.yml so edits are live.
    xdg.configFile."omp/agent/mcp.json" = {
      source = helpers.mkDotfilesSymlink config "features/omp/mcp.json";
    };
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
      path = "${config.xdg.configHome}/omp/agent/models.yml";
    };

    # Skills
    xdg.configFile."omp/agent/skills".source = aiShared.combinedSkillsBundle;

    # Shared context appended to omp's built-in system prompt.
    # Using APPEND rather than SYSTEM preserves omp's tool inventory and skill blocks.
    xdg.configFile."omp/agent/APPEND_SYSTEM.md" = {
      text =
        (builtins.readFile aiShared.sharedContext)
        + ''

          @${config.xdg.configHome}/omp/agent/skills/ponytail/SKILL.md
        '';
    };

    # Notification hook script (invoked manually or by extensions)
    xdg.configFile."omp/hooks/notify.sh" = {
      executable = true;
      text = aiShared.notifyScript {title = "omp";};
    };

    programs.fish.shellInit = ''
      # Point ccusage at omp session logs (pi-format) so `ccusage daily`
      # and `ccusage pi daily` pick them up automatically.
      set -x PI_AGENT_DIR $XDG_CONFIG_HOME/omp/agent/sessions

      # Create a new branch worktree and open it in omp
      function ompw
        if test (count $argv) -lt 1
          echo "Usage: ompw <branch> [base]"
          return 1
        end
        __worktree_create_new omp ".env .claude/settings.local.json" $argv
      end

      # Check out an existing branch into a worktree and open it in omp
      function ompwe
        if test (count $argv) -ne 1
          echo "Usage: ompwe <existing-branch>"
          return 1
        end
        __worktree_checkout omp ".env .claude/settings.local.json" $argv[1]
      end
    '';
  };
}
