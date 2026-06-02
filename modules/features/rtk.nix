{config, ...}: {
  flake.modules.homeManager.rtk = {pkgs-unstable, ...}: {
    home.packages = with pkgs-unstable; [rtk];

    programs.claude-code.settings.hooks = {
      PreToolUse = [
        {
          matcher = "Bash";
          hooks = [
            {
              type = "command";
              command = "~/.claude/hooks/rtk-rewrite.sh";
            }
          ];
        }
      ];
    };

    xdg.configFile."rtk/config.toml" = {
      text = ''
        [telemetry]
        enabled = false
      '';
    };
  };

  flake.modules.combined.rtk = {...}: {
    hm.imports = [config.flake.modules.homeManager.rtk];
  };
}
