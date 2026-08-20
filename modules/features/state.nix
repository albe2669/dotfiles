_: {
  flake.modules.nixos.state = {config, ...}: {
    system.stateVersion = config.opts.variables.stateVersion;
  };

  flake.modules.darwin.state = {config, ...}: {
    system.stateVersion = config.opts.variables.darwinStateVersion;
  };
}
