{config, ...}: {
  flake.modules.homeManager.rtk = {pkgs-unstable, ...}: {
    home.packages = [
      (pkgs-unstable.callPackage ../../pkgs/rtk {})
    ];

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
  };

  flake.modules.combined.rtk = {...}: {
    hm.imports = [config.flake.modules.homeManager.rtk];
  };
}
