{config, ...}: {
  flake.modules.homeManager.claude = {
    self,
    lib,
    inputs,
    system,
    pkgs-unstable,
    config,
    ...
  }: let
    pkg = pkgs-unstable.claude-code;
    notifyScript = ''
      #!/usr/bin/env bash
      input=$(cat)
      msg=$(printf '%s' "$input" | jq -r '.message // "Task complete"' 2>/dev/null || echo "Task complete")
      title="Claude Code"

      if [[ "$(uname)" == "Darwin" ]]; then
        osascript -e "display notification \"$msg\" with title \"$title\""
      elif command -v notify-send &>/dev/null; then
        notify-send "$title" "$msg"
      fi
    '';
  in {
    home.file.".claude/hooks/notify.sh" = {
      executable = true;
      text = notifyScript;
    };

    # ccstatusline package + declarative settings.json (programs.ccstatusline
    # module). Claude Code's statusLine below points at this package.
    programs.ccstatusline = {
      enable = true;
      settings = {
        version = 3;
        lines = [
          [
            {
              id = "1";
              type = "model";
              color = "cyan";
            }
            {
              id = "2";
              type = "separator";
            }
            {
              id = "3";
              type = "tokens-input";
              color = "brightBlack";
            }
            {
              id = "fe38dc05-fda2-4d3a-9fde-2021140e392d";
              type = "separator";
            }
            {
              id = "94349446-72cb-4aec-9fec-f371bdc34689";
              type = "tokens-output";
            }
            {
              id = "7892b992-08d7-4ef9-b613-66e12ae8b057";
              type = "flex-separator";
            }
            {
              id = "5";
              type = "git-branch";
              color = "magenta";
            }
            {
              id = "6";
              type = "separator";
            }
            {
              id = "7";
              type = "git-changes";
              color = "yellow";
            }
            {
              id = "0ecb9131-2c89-48e7-8738-0056522d39b6";
              type = "separator";
            }
            {
              id = "4f3f24ce-fc7c-4e52-a43c-feaae9664ad6";
              type = "free-memory";
            }
          ]
          [
            {
              id = "14210628-bbae-4fca-a09b-6f0f067813a6";
              type = "session-clock";
            }
            {
              id = "7850b984-405f-44ad-a7fc-1be46a5c5bfc";
              type = "separator";
            }
            {
              id = "3aa35e41-7c5f-4691-819b-5d6652b9eb35";
              type = "session-cost";
            }
            {
              id = "fb764e15-4ce0-416b-b67d-da943e7d606f";
              type = "separator";
            }
            {
              id = "7a881317-6ed7-4e6b-a5c2-a7b8fac91ce5";
              type = "skills";
            }
            {
              id = "2f486639-3611-4ba1-bcbe-d1de8868f7c5";
              type = "flex-separator";
            }
            {
              id = "5c862902-53f5-43ad-b3ff-afd5af4ddf8b";
              type = "context-bar";
            }
          ]
          [
          ]
        ];
        flexMode = "full-until-compact";
        compactThreshold = 60;
        colorLevel = 2;
        inheritSeparatorColors = false;
        globalBold = false;
        gitCacheTtlSeconds = 5;
      };
    };

    programs.claude-code = {
      enable = true;
      package = pkg;

      settings = {
        # Status line is rendered by the pinned, Nix-built ccstatusline package
        # (see pkgs/ccstatusline and the programs.ccstatusline module) rather
        # than fetching it from npm at runtime, so it is fully declarative and
        # reproducible. Its appearance is configured declaratively via
        # programs.ccstatusline.settings.
        statusLine = {
          type = "command";
          command = lib.getExe config.programs.ccstatusline.package;
          padding = 0;
        };

        enabledPlugins = {
          "gopls-lsp@claude-plugins-official" = true;
          "lua-lsp@claude-plugins-official" = true;
          "pr-review-toolkit@claude-plugins-official" = true;
          "frontend-design@claude-plugins-official" = true;
          "code-review@claude-plugins-official" = true;
          "commit-commands@claude-plugins-official" = true;
          "superpowers@superpowers-marketplace" = true;
          "context-mode@context-mode" = true;
        };

        permissions = {
          deny = [
            "Bash(sudo *)"
            "Bash(rm -rf /*)"
            "Read(.env)"
            "Read(**/.env*)"
          ];

          allow = [
            # Shell tools
            "Bash(find:*)"
            "Bash(ls:*)"
            "Bash(grep:*)"

            # Nix tools
            "Bash(nix flake metadata:*)"
            "Bash(nix eval*)"

            # Go tools
            "Bash(go vet:*)"
            "Bash(go fmt:*)"
            "Bash(go test:*)"
            "Bash(go build:*)"
            "Bash(go list:*)"
            "Bash(golangci-lint:*)"

            # Rust tools
            "Bash(cargo check:*)"
            "Bash(cargo clippy:*)"
            "Bash(cargo fmt:*)"

            # Web search
            "WebSearch"
            "WebFetch(domain:docs.dagger.io)"
            "WebFetch(domain:github.com)"
            "WebFetch(domain:dagger.io)"

            # Docker tools
            "Bash(docker images:*)"
            "Bash(docker compose:*)"

            # Git tools
            "Bash(git add:*)"
            "Bash(git:*)"

            # RTK
            "Bash(rtk:*)"
          ];
          model = "claude-sonnet-4-6";
        };

        hooks = {
          Notification = [
            {
              hooks = [
                {
                  type = "command";
                  command = "~/.claude/hooks/notify.sh";
                }
              ];
            }
          ];
          Stop = [
            {
              hooks = [
                {
                  type = "command";
                  command = "~/.claude/hooks/notify.sh";
                }
              ];
            }
          ];
        };
      };

      context = builtins.readFile ./ai-shared/context.md;

      skills = {
        fix-lint = ''
          ---
          name: fix-lint
          description: "For fixing go code. Run golangci-lint, fix all issues, and confirm tests pass"
          ---

          # Fix Lint Errors
          1. Run `golangci-lint run ./...` and capture output
          2. Fix ALL reported issues across all files
          3. Re-run linter to confirm zero issues
          4. Run `go test ./...` to ensure fixes don't break tests
          5. Only report done when both linter and tests pass clean
        '';
      };

      marketplaces = {
        claude-plugins-official = pkgs-unstable.fetchFromGitHub {
          owner = "anthropics";
          repo = "claude-plugins-official";
          rev = "de573bd84695c6657b28f05ffe32c37bb54d1f55";
          sha256 = "sha256-L9Q9ruBMPnUA4/a+7NFS/+PuzqZI6zxBEjpUk2Gn/bY=";
        };
        superpowers-marketplace = pkgs-unstable.fetchFromGitHub {
          owner = "obra";
          repo = "superpowers-marketplace";
          rev = "6fd4507659784c351abbd2bc264c7162cfd386dc";
          sha256 = "sha256-6FuI+4fTxcp3kp1WpJFMRUZnAGRRcTGJ1ZzOLgpMWVE=";
        };
        context-mode = pkgs-unstable.fetchFromGitHub {
          owner = "mksglu";
          repo = "context-mode";
          rev = "e17427240897ea8b07006382fecfac825d66e003";
          sha256 = "sha256-6FuI+4fTxcp3kp1WpJFMRUZnAGRRcTGJ1ZzOLgpMWVE=";
        };
      };
    };

    home.activation.installBetterSqlite3 = lib.hm.dag.entryAfter ["writeBoundary"] ''
      export PATH="${pkgs-unstable.nodejs}/bin:$PATH"
      MODULES_DIR="$HOME/.local/share/claude-node-modules"
      SQLITE_DIR="$MODULES_DIR/node_modules/better-sqlite3"
      NODE_VER=$(node --version 2>/dev/null || echo "unknown")
      VERSION_FILE="$MODULES_DIR/.node-version"
      if [ ! -d "$SQLITE_DIR" ] || [ "$(cat "$VERSION_FILE" 2>/dev/null)" != "$NODE_VER" ]; then
        mkdir -p "$MODULES_DIR"
        npm install 'better-sqlite3@^12.6.2' --prefix "$MODULES_DIR" --no-save --loglevel error 2>&1 || true
        printf '%s' "$NODE_VER" > "$VERSION_FILE"
      fi
    '';

    programs.fish.shellInit = ''
      set -x NODE_PATH $HOME/.local/share/claude-node-modules/node_modules $NODE_PATH

      # Shared helper: copy common config files into a worktree
      function __worktree_copy_files
        set path $argv[1]
        set files ".env" ".claude/settings.local.json" "./claude/claude.md"
        for file in $files
          if test -f $file
            mkdir -p $path/(dirname $file)
            cp $file $path/$file
          end
        end
      end

      # Shared helper: announce and launch an AI tool inside a worktree
      function __worktree_launch
        set path $argv[1]
        set tool $argv[2]
        set branch $argv[3]
        echo "Worktree for branch $branch created at $path"
        echo "Starting $tool in $path..."
        cd $path
        $tool
      end

      # Create a new branch worktree and open it in claude-code
      function claw
        if test (count $argv) -ne 1
          echo "Usage: claw <branch> <?base>"
          return 1
        end
        set branch $argv[1]

        set base ""
        if test (count $arbv) -eq 2
          set base $argv[2]
        else
          set base "main"
        end

        if git rev-parse --verify $base > /dev/null 2>&1
          echo "Using base branch $base"
        else
          echo "Base branch $base does not exist. Please choose an existing branch or omit the base to use main."
          return 1
        end

        set path "./.claude/worktrees/$branch"
        if git rev-parse --verify $branch > /dev/null 2>&1
          echo "Branch $branch already exists. Please choose a different name."
          return 1
        else
          git worktree add -b $branch $path $base
        end
        __worktree_copy_files $path
        __worktree_launch $path claude $branch
      end

      # Checkout an existing branch into a worktree and open it in claude-code
      function clawe
        if test (count $argv) -ne 1
          echo "Usage: clawe <existing-branch>"
          return 1
        end
        set branch $argv[1]
        set basepath "./.claude/worktrees"
        set path "$basepath/$branch"
        mkdir -p $basepath
        if not git rev-parse --verify $branch > /dev/null 2>&1
          echo "Branch $branch does not exist. Please choose an existing branch."
          return 1
        end
        git worktree add --checkout $path $branch
        __worktree_copy_files $path
        __worktree_launch $path claude $branch
      end

      # Create a new branch worktree and open it in opencode
      function oclaw
        if test (count $argv) -ne 1
          echo "Usage: oclaw <branch>"
          return 1
        end
        set branch $argv[1]
        set path "./.claude/worktrees/$branch"
        if git rev-parse --verify $branch > /dev/null 2>&1
          echo "Branch $branch already exists. Please choose a different name."
          git worktree add $path $branch
        else
          git worktree add -b $branch $path main
        end
        __worktree_copy_files $path
        __worktree_launch $path opencode $branch
      end

      # Checkout an existing branch into a worktree and open it in opencode
      function oclawe
        if test (count $argv) -ne 1
          echo "Usage: oclawe <existing-branch>"
          return 1
        end
        set branch $argv[1]
        set basepath "./.claude/worktrees"
        set path "$basepath/$branch"
        mkdir -p $basepath
        if not git rev-parse --verify $branch > /dev/null 2>&1
          echo "Branch $branch does not exist. Please choose an existing branch."
          return 1
        end
        git worktree add --checkout $path $branch
        __worktree_copy_files $path
        __worktree_launch $path opencode $branch
      end
    '';

    home.packages =
      lib.optionals (builtins.match ".*-linux" system != null) [
        pkgs-unstable.libnotify
      ]
      ++ [
        inputs.ccusage.outputs.packages.${system}.default
        pkgs-unstable.bun
      ];
  };

  flake.modules.combined.claude = {...}: {
    hm.imports = [
      config.flake.modules.homeManager.claude
      config.flake.modules.homeManager.ccstatusline
    ];
  };
}
