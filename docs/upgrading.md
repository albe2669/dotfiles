# Upgrading
To upgrade the version of NixOS DO NOT CHANGE THE STATEVERSION

Instead:
- Change inputs.nixpkgs.url to the new version in `flake.nix`
- Change inputs.home-manager.url to the new version in `flake.nix`
- Run `make update`
- Run `make rebuild`
- Reboot
