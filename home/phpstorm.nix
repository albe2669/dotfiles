{
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable; [
    (jetbrains.plugins.addPlugins pkgs-unstable.jetbrains.phpstorm [
      "github-copilot"
    ])
  ];
}
