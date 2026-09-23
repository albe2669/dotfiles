{
  category = "System software";
  name = "state";

  nixos = {config, ...}: {
    system.stateVersion = config.opts.variables.stateVersion;
  };

  darwin = {config, ...}: {
    system.stateVersion = config.opts.variables.darwinStateVersion;
  };
}
