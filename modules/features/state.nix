{config, ...}: let
  flakeConfig = config;
in {
  flake.modules.nixos.state = {config, ...}: {
    system.stateVersion = config.opts.variables.stateVersion;
  };

  flake.modules.darwin.state = {config, ...}: {
    system.stateVersion = config.opts.variables.darwinStateVersion;
  };

  flake.modules.combined.state = {system, ...}: let
    isDarwin = builtins.match ".*-darwin" system != null;
  in {
    imports = [
      (if isDarwin
      then flakeConfig.flake.modules.darwin.state
      else flakeConfig.flake.modules.nixos.state)
    ];
  };
}
