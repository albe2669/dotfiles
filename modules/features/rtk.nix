{
  self,
  system,
  ...
}: {
  home.packages = [
    self.packages.${system}.rtk
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
}
