_: let
  mkShell = extra: {
    pkgs,
    config,
    ...
  }:
    {
      programs.fish.enable = true;
      environment.shells = with pkgs; [
        bash
        fish
      ];
      users.users."${config.opts.variables.username}".shell = pkgs.fish;
    }
    // (extra pkgs);
in {
  flake.modules.nixos.shell = mkShell (pkgs: {
    users.defaultUserShell = pkgs.fish;
  });

  flake.modules.darwin.shell = mkShell (pkgs: {
    environment.variables.SHELL = "${pkgs.fish}/bin/fish";
  });

  flake.modules.homeManager.shell = {
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
        envLines = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (k: v: "set -gx ${k} ${v}") config.shell.envVars
        );
        pathLines = lib.concatStringsSep "\n" (map (p: "fish_add_path ${p}") config.shell.paths);
      in ''
        ${envLines}
        ${pathLines}
        ${config.shell.initExtra}
      '';
    };
  };
}
