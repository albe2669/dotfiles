let
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
  category = "Tools";
  name = "shell";

  nixos = mkShell (pkgs: {
    users.defaultUserShell = pkgs.fish;
  });

  darwin = mkShell (pkgs: {
    environment.variables.SHELL = "${pkgs.fish}/bin/fish";
  });

  homeManager = {
    pkgs,
    config,
    lib,
    ...
  }: let
    liveEnv = lib.filterAttrs (_: v: v != null) config.shell.envVars;
    # Fish allows \' inside single quotes; bash needs the 'foo'\''bar' concat.
    fishEscape = s: "'" + lib.replaceStrings ["'"] ["\\'"] (toString s) + "'";
    bashEscape = s: "'" + lib.replaceStrings ["'"] ["'\\''"] (toString s) + "'";
    varNames = lib.concatStringsSep " " (builtins.attrNames liveEnv);
    coreutils = "${pkgs.coreutils}/bin";
    fishScript = pkgs.writeText "live-env-vars.fish" (
      lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "set -Ux ${k} ${fishEscape v}") liveEnv)
    );
  in {
    imports = [../../lib/shell-options.nix];

    home.sessionVariables = config.shell.envVars;
    home.sessionPath = config.shell.paths;

    home.activation.liveEnvVars = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -v DRY_RUN ]; then
        # Erase variables that were live-pushed before but are no longer in shell.envVars.
        STATE="${"$"}{XDG_STATE_HOME:-$HOME/.local/state}/live-env-vars"
        FISH="${lib.getExe pkgs.fish}"
        CURRENT=$("${coreutils}/printf" '%s\n' ${varNames} | "${coreutils}/sort")

        if [ -f "$STATE" ]; then
          while read -r VAR; do
            [ -n "$VAR" ] || continue
            $FISH -c "set -e $VAR"
            ${lib.optionalString config.opts.variables.isDarwin ''
        launchctl unsetenv "$VAR"
      ''}
          done < <("${coreutils}/comm" -23 "$STATE" <(printf '%s\n' "$CURRENT"))
        fi

        "${coreutils}/mkdir" -p "$("${coreutils}/dirname" "$STATE")"
        printf '%s\n' "$CURRENT" > "$STATE"

        # Push every variable as an exported fish universal variable.
        # A running fish shell reads universal variables without a restart.
        if [ -n "${varNames}" ]; then
          "$FISH" "${fishScript}"
        fi
        ${lib.optionalString config.opts.variables.isDarwin ''
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (k: v: "launchctl setenv ${k} ${bashEscape v}") liveEnv
        )}
      ''}
      fi
    '';

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
