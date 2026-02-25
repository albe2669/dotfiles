{pkgs-unstable, ...}: {
  programs.claude-code = {
    enable = true;
    package = pkgs-unstable.claude-code;

    settings = {
      permissions = {
        allow = [
          "Bash(find:*)"
          "Bash(ls:*)"
          "Bash(nix flake metadata:*)"
          "Bash(go vet:*)"
          "Bash(go fmt:*)"
          "Bash(go test:*)"
          "Bash(go build:*)"
          "Bash(golangci-lint:*)"
          "Bash(cargo check:*)"
          "Bash(cargo clippy:*)"
          "Bash(cargo fmt:*)"
        ];
      };
    };
  };
}
