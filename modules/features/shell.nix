{config, ...}: let
  flakeConfig = config;
in {
  flake.modules.nixos.shell = {
    pkgs,
    config,
    ...
  }: {
    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;
    environment.shells = with pkgs; [bash fish];
    users.users."${config.opts.variables.username}".shell = pkgs.fish;
  };

  flake.modules.darwin.shell = {
    pkgs,
    config,
    ...
  }: {
    programs.fish.enable = true;
    environment.shells = with pkgs; [bash fish];
    environment.variables.SHELL = "${pkgs.fish}/bin/fish";
    users.users."${config.opts.variables.username}".shell = pkgs.fish;
  };

  flake.modules.homeManager.shell = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = [../../lib/shell-options.nix];

    home.sessionVariables = config.shell.envVars;
    home.sessionPath = config.shell.paths;

    programs.fish = {
      enable = true;
      shellAliases = config.shell.aliases;
      shellAbbrs = config.shell.abbreviations;
      shellInit = let
        envLines = lib.concatStringsSep "\n"
        (lib.mapAttrsToList (k: v: "set -gx ${k} ${v}") config.shell.envVars);
        pathLines = lib.concatStringsSep "\n"
        (map (p: "fish_add_path ${p}") config.shell.paths);
      in ''
        ${envLines}
        ${pathLines}
        ${config.shell.initExtra}
      '';
    };
  };

  flake.modules.combined.shell = {system, ...}: let
    isDarwin = builtins.match ".*-darwin" system != null;
  in {
    imports = [
      (if isDarwin
      then flakeConfig.flake.modules.darwin.shell
      else flakeConfig.flake.modules.nixos.shell)
    ];
    hm.imports = [flakeConfig.flake.modules.homeManager.shell];
  };
}
