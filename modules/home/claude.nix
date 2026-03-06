{pkgs-unstable, ...}: {
  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;

    settings = {
      permissions = {
        allow = [
          # Shell tools
          "Bash(find:*)"
          "Bash(ls:*)"
          "Bash(grep:*)"

          # Nix tools
          "Bash(nix flake metadata:*)"

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
    		echo "Usage: git-worktree-add <branch>"
    		return 1
    	end

    	set branch $argv[1]
    	set path "./.claude/worktrees/$branch"

    	# Check if the branch already exists
    	if git rev-parse --verify $branch > /dev/null 2>&1
    		echo "Branch $branch already exists. Please choose a different name."
    		git worktree add $path $branch
    	else
    		git worktree add -b $branch $path
    	end


    	if test -f .env
    		cp .env $path/.env
    	end

    	if test -f .claude/settings.local.json
    		mkdir -p $path/.claude
    		cp .claude/settings.local.json $path/.claude/settings.local.json
    	end

    	echo "Worktree for branch $branch created at $path"
    	echo "Starting claude-code in $path..."
    	cd $path
    	claude
    end
  '';
}
