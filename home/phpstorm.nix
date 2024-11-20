{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    (jetbrains.plugins.addPlugins pkgs.jetbrains.phpstorm [
      "github-copilot"
    ])
  ];
}
