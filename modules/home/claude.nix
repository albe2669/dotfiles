{
  self,
  system,
  pkgs-unstable,
  ...
}: let
  pkg = pkgs-unstable.claude-code;
in {
  programs.claude-code = {
    enable = true;
    package = pkg;

    settings = {
      permissions = {
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
    };
  };

  # Fish functions to manage git worktrees for AI coding sessions
  programs.fish.shellInit = ''
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

  home.packages = [
    self.packages.${system}.ccusage
  ];
}
