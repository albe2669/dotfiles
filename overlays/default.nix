{inputs, ...}: [
  (import ./basedpyright.nix)
  # (import ./claude.nix)
  (import ./golangci-lint.nix)
  # (import ./jetbrains.nix)
  (import ./tinycast.nix)
  inputs.claude-code.overlays.default
]
