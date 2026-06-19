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
  in {
    home.packages =
      [pkg]
      ++ lib.optionals (builtins.match ".*-linux" system != null) [
        pkgs-unstable.libnotify
      ];

    # Main config
    home.file.".omp/agent/config.yml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.opts.variables.dotfilesLocation}" + (builtins.toPath "/modules/features/omp/config.yml");
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
