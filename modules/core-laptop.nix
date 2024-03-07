{...}: {
  imports = [
    # Also included by default in core-server
    ./services/power.nix
    ./services/tlp.nix
  ];

  # TODO: This might horribly break if you ever switch to an AMD CPU
  services.thermald.enable = true;
}
