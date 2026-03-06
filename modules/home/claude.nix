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
}
