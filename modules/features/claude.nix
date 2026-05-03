{config, ...}: {
  flake.modules.homeManager.claude = {
    self,
    lib,
    system,
    pkgs-unstable,
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

    programs.claude-code = {
      enable = true;
      package = pkg;

      settings = {
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

      context = ''
        ## Commands
        If a just or make file is present, then read the commands and their descriptions before guessing at which commands to run for tasks like linting, testing, or building. Do not assume which commands are used without checking for existing definitions.

        Always run the command directly instead of through make/just, but derive it from the make/just file if it exists.

        ## Development

        When debugging issues, confirm the correct target (host, service, file) with the user before starting investigation. Do not assume which component is affected.

        Always update and run tests and documentation after making a change.

        ## Go Development

        Always run `golangci-lint run ./...` after making Go code changes and fix any issues before presenting work as complete. Do not dismiss or skip linter output.

        Always run the relevant test suite (`go test ./...` or specific package tests) after making changes. Do not explore code extensively without running tests first when debugging test failures.

        ## Nix development

        Always run `nix flake metadata` and `nix eval` to understand the structure of the flake and available outputs before making changes.

        Always build the package/flake being modified to confirm it builds successfully after changes. Do not assume changes are correct without building.

        Always run the formatter on Nix files to ensure consistent formatting. Do not make manual formatting changes.

        ## Infrastructure / Docker

        When working with Docker/Azurite/external services, read existing config files (docker config.json, connection strings) before guessing at values like auth keys or API versions.
      '';

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
          rev = "7ed523140f506611c968a0ec32e1dfc40a1d5673";
          sha256 = "sha256-wt+D1LKRWQDPuLA0f4X2deV5LDL7+x0iz7+2BHkkAYs=";
        };
        superpowers-marketplace = pkgs-unstable.fetchFromGitHub {
          owner = "obra";
          repo = "superpowers-marketplace";
          rev = "0b73e2556d4ecf4fe54dbb32b248b5e17ed0c0f5";
          sha256 = "sha256-uKDVcw6C1uzpiIY+hjgHxr4AU9wM1KF7t3v6zd9XBHk=";
        };
        context-mode = pkgs-unstable.fetchFromGitHub {
          owner = "mksglu";
          repo = "context-mode";
          rev = "a2f108247ba6d60b04f2fc448f6322afac91cd71";
          sha256 = "sha256-myMNTAUFcx1ba9PgVMRbfV+O/UKrzm+CBy1VdBIvfI0=";
        };
      };
      settings = {
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
          echo "Usage: claw <branch>"
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
        self.packages.${system}.ccusage
        pkgs-unstable.bun
      ];
  };

  flake.modules.combined.claude = {...}: {
    hm.imports = [config.flake.modules.homeManager.claude];
  };
}
