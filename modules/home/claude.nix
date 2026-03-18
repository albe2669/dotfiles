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
        ];
      };
    };
  };

  # Fish function to create a worktree with a name, and copy .env file to it if it exists
  programs.fish.shellInit = ''
     function claw
     	if test (count $argv) -ne 1
     		echo "Usage: claw <branch>"
     		return 1
     	end

     	set branch $argv[1]
     	set path "./.claude/worktrees/$branch"

     	# Check if the branch already exists
     	if git rev-parse --verify $branch > /dev/null 2>&1
     		echo "Branch $branch already exists. Please choose a different name."
     		git worktree add $path $branch
     	else
     		git worktree add -b $branch $path main
     	end

    set files ".env" ".claude/settings.local.json" "./claude/claude.md"

    for file in $files
    	if test -f $file
    		mkdir -p $path/(dirname $file)
    		cp $file $path/$file
    	end
    end

     	echo "Worktree for branch $branch created at $path"
     	echo "Starting claude-code in $path..."
     	cd $path
     	claude
     end

     # Checks out an existing branch into a worktree, and copy .env file to it if it exists
     function clawe
     	if test (count $argv) -ne 1
     		echo "Usage: clawe <existing-branch>"
     		return 1
     	end

     	set branch $argv[1]
      set basepath "./.claude/worktrees"
     	set path "$basepath/$branch"

      mkdir -p $basepath

      # Check if the branch doesnt exist
      if not git rev-parse --verify $branch > /dev/null 2>&1
     		echo "Branch $branch does not exist. Please choose an existing branch."
     		return 1
     	end

      git worktree add --checkout $path $branch

      set files ".env" ".claude/settings.local.json" "./claude/claude.md"

      for file in $files
        if test -f $file
          mkdir -p $path/(dirname $file)
          cp $file $path/$file
        end
      end

     	echo "Worktree for branch $branch created at $path"
     	echo "Starting claude-code in $path..."
     	cd $path
     	claude
     end
  '';

  home.packages = [
    self.packages.${system}.ccusage
  ];
}
