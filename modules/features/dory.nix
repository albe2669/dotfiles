{config, ...}: {
  flake.modules.darwin.dory = _: {
    homebrew = {
      # Non-official tap; Homebrew 6.0 refuses to load casks from untrusted
      # taps, so mark it trusted.
      taps = [
        {
          name = "Augani/dory";
          trusted = true;
        }
      ];

      casks = [
        {
          # Fully-qualified name so the tap trust above resolves the cask.
          name = "Augani/dory/dory";
          # The cask installs only Docker Core. Kubernetes is a signed
          # component installed separately via `dory component install
          # kubernetes`, which only works once the Dory engine is running.
          # Run it best-effort after a cask install/upgrade so a fresh
          # install picks it up, but never block activation if Dory isn't
          # running yet or the CLI isn't on PATH. Re-running it later (or via
          # the Components screen) is harmless and idempotent.
          postinstall = ''
            command -v dory >/dev/null 2>&1 && dory component install kubernetes >/dev/null 2>&1 || true
          '';
        }
      ];
    };
  };

  flake.modules.combined.dory = {
    system,
    lib,
    ...
  }: let
    isDarwin = builtins.match ".*-darwin" system != null;
  in {
    imports = lib.optional isDarwin config.flake.modules.darwin.dory;
  };
}
