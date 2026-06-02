{inputs, ...}: [
  (import ./basedpyright.nix)
  # (import ./claude.nix)
  (import ./golangci-lint.nix)
  # (import ./jetbrains.nix)
  (import ./rtk.nix)
  inputs.claude-code.overlays.default
]
